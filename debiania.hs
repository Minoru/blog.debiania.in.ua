{-# LANGUAGE OverloadedStrings #-}

import Prelude hiding (id)
import Control.Category (id)
import Control.Arrow ((>>>), (|||), (&&&), first, second, arr)
import Data.Monoid (mempty, mconcat)
import Data.List (sort, elem, reverse)
import qualified Data.Text as T

import Hakyll

rootUrl = "http://debiania.in.ua"

main :: IO ()
main = hakyll $ do
    -- Compress CSS
    match "css/*" $ do
        route idRoute
        compile compressCssCompiler

    -- Images
    match "images/*" $ do
        route idRoute
        compile copyFileCompiler

    -- Miscellaneous files
    match "misc/*" $ do
        route idRoute
        compile copyFileCompiler

    -- Render posts
    match "posts/*" $ do
        route $ setExtension ".html"
        compile $ pageCompiler
            >>> arr (renderDateField "date" "%B %e, %Y" "Date unknown")
            >>> arr (renderDateField "datetime" "%Y-%m-%d" "")
            >>> pageHasDescription
            >>> arr (copyBodyToField "description")
                |||
                id
            >>> applyTemplateCompiler "templates/post.html"
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler

    -- Render posts list
    match "posts.html" $ route idRoute
    create "posts.html" $ constA mempty
        >>> arr (setField "title" "Archives")
        >>> requireAllA "posts/*" addPostList
        >>> applyTemplateCompiler "templates/archives.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

    -- Index
    match "index.html" $ route idRoute
    create "index.html" $ constA mempty
        >>> arr (setField "title" "Home")
        >>> requireAllA "posts/*" (second (arr $ take 8 . recentFirst)
                                   >>> addPostList)
        >>> applyTemplateCompiler "templates/posts.html"
        >>> applyTemplateCompiler "templates/index.html"
        >>> applyTemplateCompiler "templates/default.html"
        >>> relativizeUrlsCompiler

    match (list ["about.markdown", "subscribe.markdown"]) $ do
        route $ setExtension "html"
        compile $ pageCompiler
            >>> applyTemplateCompiler "templates/about.html"
            >>> applyTemplateCompiler "templates/default.html"
            >>> relativizeUrlsCompiler

    -- Page 404 needs some special treatment - no relativization, because it's
    -- gonna be located in the root
    match "404.markdown" $ do
        route $ setExtension "html"
        compile $ pageCompiler
            >>> applyTemplateCompiler "templates/about.html"
            >>> applyTemplateCompiler "templates/default.html"

    -- robots.txt should be just copied to the root
    match "robots.txt" $ do
        route idRoute
        compile copyFileCompiler

    -- Render feeds
    -- All posts
    match "feeds/all.rss" $ route idRoute
    create "feeds/all.rss" $ requireAll_ "posts/*"
        >>> arr reverse
        >>> arr (take 5)
        >>> renderRss allFeedConfiguration

    match "feeds/all.atom" $ route idRoute
    create "feeds/all.atom" $ requireAll_ "posts/*"
        >>> arr reverse
        >>> arr (take 5)
        >>> renderAtom allFeedConfiguration

    -- Russian only
    match "feeds/russian.rss" $ route idRoute
    create "feeds/russian.rss" $ russianPosts
        >>> arr reverse
        >>> arr (take 5)
        >>> renderRss russianFeedConfiguration

    match "feeds/russian.atom" $ route idRoute
    create "feeds/russian.atom" $ russianPosts
        >>> arr reverse
        >>> arr (take 5)
        >>> renderAtom russianFeedConfiguration

    -- English only
    match "feeds/english.rss" $ route idRoute
    create "feeds/english.rss" $ englishPosts
        >>> arr reverse
        >>> arr (take 5)
        >>> renderRss englishFeedConfiguration

    match "feeds/english.atom" $ route idRoute
    create "feeds/english.atom" $ englishPosts
        >>> arr reverse
        >>> arr (take 5)
        >>> renderAtom englishFeedConfiguration

    -- Linux-related, russian - feed for runix.org
    match "feeds/linux-rus.rss" $ route idRoute
    create "feeds/linux-rus.rss" $ linuxRussianPosts
        >>> arr reverse
        >>> arr (take 5)
        >>> renderRss linuxRussianFeedConfiguration

    match "feeds/linux-rus.atom" $ route idRoute
    create "feeds/linux-rus.atom" $ linuxRussianPosts
        >>> arr reverse
        >>> arr (take 5)
        >>> renderAtom linuxRussianFeedConfiguration

    -- Read templates
    match "templates/*" $ compile templateCompiler

{---- COMPILERS ----}

-- | Auxiliary compiler: generate a post list from a list of given posts, and
-- add it to the current page under @$posts@
--
addPostList :: Compiler (Page String, [Page String]) (Page String)
addPostList = setFieldA "posts" $
    arr recentFirst
        >>> require "templates/postitem.html" (\p t -> map (applyTemplate t) p)
        >>> arr mconcat
        >>> arr pageBody

-- | Splits control flow in two depending on page having description or not
pageHasDescription :: Compiler (Page a) (Either (Page a) (Page a))
pageHasDescription = arr (\p -> if hasDescription p then Right p else Left p)


{---- PREDICATES ----}

-- | Helper function to determine if a page has a @description@ field
hasDescription :: Page a -> Bool
hasDescription = (/= "") . getField "description"

-- | Helper function to determine if given page is written in Russian.
-- Tries @lang@ and @language@ fields first, then uses some homebrew heuristics
-- (is at least 20% of characters cyryllic?)
isRussian :: Page String -> Bool
isRussian p = field || heuristics
  where
    field = any (\l -> l == "ru" || l == "rus") [ getField "language" p
                                                , getField "lang" p ]
    heuristics = counted >= (T.length text `div` 20)
    counted = sum $ map snd $ filter ((`elem` russian) . fst) $ countChars text
    countChars = map (\t -> (T.head t, T.length t)) . T.group
    text = T.toCaseFold $ T.pack $ sort $ pageBody p

    russian = "йцукенгшщзхъфывапролджэячсмитьбю"

-- | Helper function to check if @category@ field contains "debian"
isDebianRelated = ("debian" `elem`) . map T.unpack . T.splitOn " ," . T.pack
    . getField "category"

-- | Helper function to check if @category@ field contains "linux"
isLinuxRelated = ("linux" `elem`) . map T.unpack . T.splitOn " ," . T.pack
    . getField "category"


{---- FEED-RELATED COMPILERS ----}

-- | Returns feed entries coresponding to posts written in Russian
russianPosts = requireAll_ "posts/*" >>> arr (filter isRussian)

-- | Returns feed entries coresponding to posts written in English (actually,
-- anything but Russian)
englishPosts = requireAll_ "posts/*" >>> arr (filter (not . isRussian))

-- | Returns feed entries corresponding to posts written in Russian about Linux
linuxRussianPosts = requireAll_ "posts/*"
    >>> arr (filter (\p -> isLinuxRelated p || isDebianRelated p))
    >>> arr (filter isRussian)


{---- FEED CONFIGURATIONS ----}

allFeedConfiguration :: FeedConfiguration
allFeedConfiguration = FeedConfiguration
    { feedTitle = "Debiania, yet another Debian blog"
    , feedDescription = "All posts"
    , feedAuthorName = "Alexander Batischev"
    , feedRoot = rootUrl
    }

russianFeedConfiguration :: FeedConfiguration
russianFeedConfiguration = FeedConfiguration
    { feedTitle = "Debiania, ещё один блог о Debian"
    , feedDescription = "Посты на русском"
    , feedAuthorName = "Александр Батищев"
    , feedRoot = rootUrl
    }

englishFeedConfiguration :: FeedConfiguration
englishFeedConfiguration = FeedConfiguration
    { feedTitle = "Debiania, yet another Debian blog"
    , feedDescription = "Posts in English only"
    , feedAuthorName = "Alexander Batischev"
    , feedRoot = rootUrl
    }

linuxRussianFeedConfiguration :: FeedConfiguration
linuxRussianFeedConfiguration = FeedConfiguration
    { feedTitle = "Debiania, ещё один блог о Debian"
    , feedDescription = "О Linux"
    , feedAuthorName = "Александр Батищев"
    , feedRoot = rootUrl
    }

