---
title: XF86KScreenSaver
published: 2012-02-15T22:30:00Z
categories: 
tags: linux, howto, debian
description: Учим Linux корректно обрабатывать одну спецкнопочку моего ноутбука.
---

На пробельной клавише [моего Asus P52F-380M](/posts/2011-08-30-asus-p52f-380m-and-debian.html) нарисован какой-то бегущий человечек (JFYI: клавиши у P52F не такие, как на фото, но это не важно):

<div class="center">
<img src="/images/asus-p52f-so003x.jpg"
    width="400px" height="94px"
    loading="lazy"
    alt="Git-annex web UI"
    class="bleed" />
</div>

<code>xev</code> услужливо подсказал, что в комбинации с Fn пробел генерирует специальный код — <code>XF86KScreenSaver</code>. Я немного параноик и постоянно блокирую клавиатуру с помощью <code>xtrlock</code>, запуская последний при помощи Xmonad'овского <a href='http://hackage.haskell.org/packages/archive/xmonad-contrib/0.10/doc/html/XMonad-Prompt-Shell.html#v:shellPrompt'><code>shellPrompt</code></a> (аналоги в других WM/DE/OS: Alt-R, WinKey-R), что, согласитесь, не верх удобства. В общем, забиндил я на этот код вызов <code>xtrlock</code> и нарадоваться не могу — теперь вместо Alt-P, xtr, &lt;Enter&gt; я просто жму Fn-Space и убегаю ☺ Жаль, что на нетбуке такой фичи нет…

<h3 id='hakyll-convert-comments-title'>Comments (migrated from Blogger)</h3>
<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-02-16T19:59:44.350+02:00, Анонимный wrote:</p>
<p class='hakyll-convert-comment-body'>
А ctrl+alt+L в xmonad нету?
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-02-16T22:16:01.192+02:00, cF8 wrote:</p>
<p class='hakyll-convert-comment-body'>
А я уже довольно давно использую для этого сочетание r_Super+Menu в dwm, жмется правой рукой двумя пальцами, очень удобно :3
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-02-16T22:39:19.571+02:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
<b>Анонимный</b>, по умолчанию — нет. Но это ж не Windows, всё настраиваемо.

<b>cF8</b>, у меня и r_Super-то нету :)
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-02-19T10:15:26.626+02:00, Анонимный wrote:</p>
<p class='hakyll-convert-comment-body'>
&gt;  r_Super+Menu<br/>
а разве это не одна итаже клавиша &quot;Шиндовш&quot;?
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-02-20T00:05:58.337+02:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
<b>Анонимный</b>, нет. Menu — это клавиша открытия контекстного меню, находится справа от r_Super.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-03-29T11:30:24.518+03:00, imelnik wrote:</p>
<p class='hakyll-convert-comment-body'>
Ещё с виндовых времён привык к Super+L, на openbox так и оставил. Универсально и запоминается.
</p>
</div>



