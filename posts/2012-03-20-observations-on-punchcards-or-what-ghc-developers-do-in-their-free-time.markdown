---
title: Наблюдения о punchcard'ах некоторых проектов, или Чем занимаются на досуге разработчики GHC?
published: 2012-03-20T19:29:00Z
categories: 
tags: linux,debian
---

Бесцельно ползая по github'у длинным вторничным вечером (уф, что-то давненько не случалось таких вечеров!), наткнулся на любопытные, как мне кажется, закономерности в punchcard'ах некоторых проектов.<br /><br />Punchcard — это декартова плоскость, где по одной оси идёт время суток, а по другой — день недели. Размер точек на пересечениях дня и времени показывает, как много коммитов было сделано в такие время и день. В каком-нибудь вялотекущем любительском проектике punchcard будет содержать всего пяток точек, в то время как в огромном проекте точки почти равного размера будут равномерно распределены по всей плоскости.<br /><br />Итак, поехали!<br /><a name='more'></a><br />Начнём, пожалуй, с punchcard'а <a href='http://www.haskell.org/ghc/'>GHC</a>, The Glasgow Haskell Compiler:<br /><br /><div class="separator" style="clear: both; text-align: center;"><a href="http://4.bp.blogspot.com/-DREX2TokF0M/T2jRKSf0NsI/AAAAAAAAAoI/MJ-f29eGjfQ/s1600/ghc.png" imageanchor="1" style="margin-left:1em; margin-right:1em"><img border="0" height="225" width="600" src="http://4.bp.blogspot.com/-DREX2TokF0M/T2jRKSf0NsI/AAAAAAAAAoI/MJ-f29eGjfQ/s400/ghc.png" /></a></div><br />GHC является академическим проектом, и пилят его, судя по всему, по большей части в рабочее время, с восьми до пяти. Ничего интересного.<br /><br />По крайней мере, пока вы не посмотрели на punchcard <a href='http://www.postgresql.org/'>PostgreSQL</a>:<br /><br /><div class="separator" style="clear: both; text-align: center;"><a href="http://2.bp.blogspot.com/-H3JTEhADwAI/T2jSiqpBoHI/AAAAAAAAAoU/Drq4IDeRuHg/s1600/postgres.png" imageanchor="1" style="margin-left:1em; margin-right:1em"><img border="0" height="225" width="600" src="http://2.bp.blogspot.com/-H3JTEhADwAI/T2jSiqpBoHI/AAAAAAAAAoU/Drq4IDeRuHg/s400/postgres.png" /></a></div><br />Теперь понятно, чем занимаются разработчики GHC, когда они не на работе ☺<br /><br />На самом же деле PostgreSQL является СУБД, разрабатываемой сообществом без поддержки корпораций (как в случае с MySQL), так что такая картина вполне ожидаема.<br /><br />А что же со светом наших сердец — <a href='http://kernel.org/'>ядром Linux</a>?<br /><br /><div class="separator" style="clear: both; text-align: center;"><a href="http://3.bp.blogspot.com/-CaHDoOxrjV4/T2jTi37VImI/AAAAAAAAAog/pBfkQoAKp08/s1600/linux.png" imageanchor="1" style="margin-left:1em; margin-right:1em"><img border="0" height="225" width="600" src="http://3.bp.blogspot.com/-CaHDoOxrjV4/T2jTi37VImI/AAAAAAAAAog/pBfkQoAKp08/s400/linux.png" /></a></div><br />Честно говоря, меня такая картина шокировала. Да, я в курсе, что многие разработчики Linux работают в Red Hat и потому в основном коммитят в рабочее время, но чтобы эти коммиты составляли <b>настолько</b> заметную часть общего потока… Весьма, весьма неожиданно.<br /><br />После Linux моё внимание, естественно, привлекла <a href='http://gcc.gnu.org/'>GCC</a>, GNU Compiler Collection:<br /><br /><div class="separator" style="clear: both; text-align: center;"><a href="http://2.bp.blogspot.com/-9-SSnIvCuyg/T2jVfJr7isI/AAAAAAAAAos/fWdNpOOEyYI/s1600/gcc.png" imageanchor="1" style="margin-left:1em; margin-right:1em"><img border="0" height="225" width="600" src="http://2.bp.blogspot.com/-9-SSnIvCuyg/T2jVfJr7isI/AAAAAAAAAos/fWdNpOOEyYI/s400/gcc.png" /></a></div><br />Судя по картинке, разработчики GCC все до единого садятся за компьютеры в семь утра, работают до одиннадцати, обедают, потом работают до часу ночи и валятся спать. Каждый день в полночь происходит стресс-тест git'а и прочей инфраструктуры — все коммитят всё, что попалось под руку (отсюда красивенький столбец слева). Суббота и воскресенье — прогулки^Wпоездки на конференции. Суровые программисты на Си, чо. ☺<br /><br />Вся эта красота и равномерность заставила меня пойти искать что-нибудь этакое, и вот результат:<br /><br /><div class="separator" style="clear: both; text-align: center;"><a href="http://4.bp.blogspot.com/-c8kngMFam-U/T2jXg5h-9cI/AAAAAAAAAo4/D08Y5_59m4I/s1600/clojure.png" imageanchor="1" style="margin-left:1em; margin-right:1em"><img border="0" height="225" width="600" src="http://4.bp.blogspot.com/-c8kngMFam-U/T2jXg5h-9cI/AAAAAAAAAo4/D08Y5_59m4I/s400/clojure.png" /></a></div><br />Это punchcard <a href='http://clojure.org/'>Clojure</a>, диалекта Lisp, ориентированного на JVM. Проект, насколько мне известно, начинался как хак, но быстро обрёл популярность и сейчас является, наверное, самым живым и бурно развивающимся Лиспом. Собственно, по картинке это сразу видно: народ пилит и пилит код, так что коммиты никак не упорядочены. Пробелы в районе пяти–шести утра — это, судя по всему, моменты, когда организм не выдерживает гонки и просто выключается на сутки ☺<br /><br />Очень жаль, что на github'е нет зеркал таких проектов, как zsh, vim, urxvt, Firefox, mutt и прочих — я бы с огромным удовольствием полюбовался на их статистику. Также прошу прощения у тех читателей, кому на протяжении первых пары абзацев не хватало картинок — я честно хотел вставить туда punchcard одного из моих проектиков, но github сказал, что «this graph is not avaliable yet» ☹ Напоследок, если кого-то это раздражает — извините за обилие смайликов.<br /><br />P.S. (Точнее, P.P. — <i>post postum</i>): это сотый пост. Ура!

<h3 id='hakyll-convert-comments-title'>Comments (migrated from Blogger)</h3>
<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-03-21T14:55:10.396+02:00, DemAS wrote:</p>
<p class='hakyll-convert-comment-body'>
А с помощью его получены такие картинки ?
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-03-21T20:16:31.128+02:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
С помощью веб-интерфейса github.com. У каждого проекта есть вкладка Stats &amp; Graphs, где приводится всякая статистика, в том числе punchcard. Возможно, что-то подобное можно рисовать какими-нибудь standalone утилитами.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-03-26T17:28:14.931+03:00, Анонимный wrote:</p>
<p class='hakyll-convert-comment-body'>
Спасибо, интересное наблюдение!
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-04-23T21:32:08.367+03:00, F@stto wrote:</p>
<p class='hakyll-convert-comment-body'>
А сейчас на github punchcard не работает? прошелся по проектам, везде написано not avaliable yet - третий день подряд наблюдаю... раньше не замечал (не смотрел просто)
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-04-23T22:38:50.699+03:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
Да, многие графики уже давно недоступны — даже когда я этот пост писал, нельзя было посмотреть punchcard&#39;ы для более мелких проектов. Не знаю, почему так.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-04-25T09:31:47.968+03:00, F@stto wrote:</p>
<p class='hakyll-convert-comment-body'>
Только что зашел на github - все, в графиках вкладка punchcard исчезла совсем... жалко
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-04-25T23:57:50.703+03:00, F@stto wrote:</p>
<p class='hakyll-convert-comment-body'>
Вау, на житхабе новые графики, работает все! + добавлены новые возможности.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2012-04-26T02:07:37.219+03:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
И правда! Traffic graph пока что выключен, потому что нашли какой-то баг, но в остальном всё работает. Круто!
</p>
</div>


