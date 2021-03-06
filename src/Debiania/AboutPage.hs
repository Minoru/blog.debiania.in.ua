{-# LANGUAGE OverloadedStrings #-}

module Debiania.AboutPage (
    aboutPageRules
) where

import Hakyll

import Debiania.Compilers
import Debiania.Context

aboutPageRules :: Rules ()
aboutPageRules = do
    let ctx = rootUrlCtx <> defaultContext

    create ["about.markdown"] $ do
        route   $ setExtension "html"
        compile $ debianiaCompiler
          >>= loadAndApplyTemplate "templates/about.html" ctx
          >>= loadAndApplyTemplate
                "templates/default.html"
                (constField "navbar-about" "Yep" <> ctx)
          >>= relativizeUrls

    create ["about.markdown"] $ version "gzipped" $ do
        route   $ setExtension "html.gz"
        compile gzipFileCompiler
