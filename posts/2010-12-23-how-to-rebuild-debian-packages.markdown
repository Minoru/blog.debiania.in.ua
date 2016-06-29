---
title: Как пересобирать пакеты Debian
published: 2010-12-23T13:47:00Z
categories: 
tags: debian
---

<p align="right">Этот пост является переводом<br />поста Рафаэля Герцога (Raphaël Hertzog)<br /><a href="http://raphaelhertzog.com/2010/12/15/howto-to-rebuild-debian-packages/">“Howto to rebuild Debian packages”</a></p><br /><br /><i><b>От переводчика</b>: мне не хотелось переводить «source package» как «исходный пакет», т.к. такой перевод может наталкивать на мысль о распаковке deb–пакета с бинарниками. Поэтому в статье использован другой перевод — «пакет исходных кодов». Звучит, конечно, убого, но всяко лучше, чем первое.</i><br /><br />Умение пересобирать пакеты Debian является очень полезным навыком. Он является необходимым для многих задач, с которыми может столкнуться администратор: включить фичу, выключенную в официальном пакете; пересобрать пакет для использования в другом дистрибутиве (например, пересобрать пакет из Debian Testing для Debian Stable — мы называем это обратным портированием (backporting)); добавить исправление бага, подготовленное разработчиками из апстрима, и так далее. Узнайте о четырёх шагах, позволяющих пересобирать пакеты Debian.<br /><a name='more'></a><br /><br /><h3>Скачивание пакета с исходным кодом</h3><br />Предпочитаемым путём получения пакетов с исходным кодом является APT. Он может скачивать их из репозиториев с исходниками, прописанных у вас в <code>/etc/apt/sources.list</code>, например:<br /><br /><div class="code"><code>deb-src http://ftp.debian.org/debian unstable main contrib non-free<br />deb-src http://ftp.debian.org/debian testing main contrib non-free<br />deb-src http://ftp.debian.org/debian stable main contrib non-free</code></div><br />Заметьте, что строки начинаются с «deb-src» вместо обычного «deb». Это говорит APT'у о том, что мы заинтересованы в пакетах с исходным кодом, а не бинарниками.<br /><br />После <code>apt-get update</code> можно использовать <code>apt-get source publican</code>, чтобы получить последнюю версию пакета с исходными кодами «publican». Можно также указать дистрибутив, из которого следует получать пакет, используя следующий синтаксис: <i>«package/distribution»</i>. <code>apt-get source publican/testing</code> получит пакет с исходниками publican и распакует их в текущую директорию (используя <code>dpkg-source -x</code>, так что вам понадобится пакет <a href="http://packages.debian.org/dpkg-dev">dpkg-dev</a>).<br /><br /><div class="code"><code>$ <b>apt-get source publican/testing</b><br />Reading package lists... Done<br />Building dependency tree<br />Reading state information... Done<br />NOTICE: 'publican' packaging is maintained in the 'Git' version control system at:<br />git://git.debian.org/collab-maint/publican.git<br />Need to get 727 kB of source archives.<br />Get:1 http://nas/debian/ squeeze/main publican 2.1-2 (dsc) [2253 B]<br />Get:2 http://nas/debian/ squeeze/main publican 2.1-2 (tar) [720 kB]<br />Get:3 http://nas/debian/ squeeze/main publican 2.1-2 (diff) [4728 B]<br />Fetched 727 kB in 0s (2970 kB/s)<br />dpkg-source: info: extracting publican in publican-2.1<br />dpkg-source: info: unpacking publican_2.1.orig.tar.gz<br />dpkg-source: info: unpacking publican_2.1-2.debian.tar.gz<br />$ <b>ls -dF publican*</b><br />publican-2.1/                 publican_2.1-2.dsc<br />publican_2.1-2.debian.tar.gz  publican_2.1.orig.tar.gz</code></div><br />Если APT использовать не хочется, или если пакет с исходными кодами лежит не в APT'овском репозитории, можно скачать его с помощью команды <code>dget -u <i>dsc-url</i></code>, где <i>dsc-url</i> — это URL .dsc–файла, представляющего пакет с сорцами. dget предоставляется пакетом <a href="http://packages.debian.org/stable/devscripts">devscripts</a>. Заметим, что опция -u отключает проверку источника пакета перед его распаковкой.<br /><br /><h3>Установка сборочных зависимостей</h3><br />И снова APT сделает за вас всю грязную работу: достаточно лишь запустить <code>apt-get build-dep foo</code>, и сборочные зависимости для пакета foo будут установлены. Он поддерживает тот же синтаксический сахар, что и <code>apt-get source</code>, так что для установки зависимостей, требуемых для сборки тестируемой версии publican, можно использовать команду <code>apt-get build-dep publican/testing</code>.<br /><br />Если пользоваться APT'ом нельзя, перейдите в директорию с распакованным исходным кодом и запустите <code>dpkg-checkbuilddeps</code>. Он покажет список неудовлетворённых сборочных зависимостей (если такие есть; в противном случае ничего выведено не будет и можно будет спокойно продолжать). Немного копирования–вставки и вызовов apt-get install — и вы за пару секунд установите все необходимые пакеты.<br /><br /><h3>Осуществление изменений</h3><br />Я не буду подробно останавливаться на этом шаге, так как он сильно зависит от преследуемых вами целей. Возможно, вам придётся править debian/rules, а может, вы просто примените патч.<br /><br />Впрочем, вне зависимости от того, сделали вы изменения или просто пересобрали пакет в другом окружении, вам следует поменять версию пакета. Это можно сделать с помощью «<code>dch --local foo</code>» (снова из пакета devscripts), где «foo» следует заменить на короткое имя, идентифицирующее вас как поставщика обновлённой версии. Эта команда обновит debian/changelog и пригласит вас написать короткую заметку о внесённых изменениях.<br /><br /><h3>Сборка пакета</h3><br />Последний шаг — самый простой, так как всё уже на своих местах. Вы должны находиться в директории с распакованными исходниками.<br /><br />Теперь запускайте либо «debuild -us -uc» (рекомендуемый выбор, требуется пакет devscripts), либо сразу «dpkg-buildpackage -us -uc». Опции «-us -uc» указывают на то, что шаг подписывания пакета будет пропущен; в противном случае в конце сборки было бы сгенерировано (безобидное) сообщение, если бы у вас не нашлось GPG–ключа для имени, указанного в первой записи в changelog'е.<br /><br /><div class="code"><code>$ <b>cd publican-2.1</b><br />$ <b>debuild -us -uc</b><br /> dpkg-buildpackage -rfakeroot -D -us -uc<br />dpkg-buildpackage: export CFLAGS from dpkg-buildflags (origin: vendor): -g -O2<br />dpkg-buildpackage: export CPPFLAGS from dpkg-buildflags (origin: vendor):<br />dpkg-buildpackage: export CXXFLAGS from dpkg-buildflags (origin: vendor): -g -O2<br />dpkg-buildpackage: export FFLAGS from dpkg-buildflags (origin: vendor): -g -O2<br />dpkg-buildpackage: export LDFLAGS from dpkg-buildflags (origin: vendor):<br />dpkg-buildpackage: source package publican<br />dpkg-buildpackage: source version 2.1-2rh1<br />dpkg-buildpackage: source changed by Raphaël Hertzog <br /> dpkg-source --before-build publican-2.1<br />dpkg-buildpackage: host architecture i386<br />[...]<br />dpkg-deb: building package `publican' in `../publican_2.1-2rh1_all.deb'.<br /> dpkg-genchanges  >../publican_2.1-2rh1_i386.changes<br />dpkg-genchanges: not including original source code in upload<br /> dpkg-source --after-build publican-2.1<br />dpkg-buildpackage: binary and diff upload (original source NOT included)<br />Now running lintian...<br />Finished running lintian.</code></div><br />Сборка завершена, обновлённые пакеты с исходным кодом и бинарниками были сгенерированы в родительской директории.<br /><br /><div class="code"><code>$ <b>cd ..</b><br />$ <b>ls -dF publican*</b><br />publican-2.1/                    publican_2.1-2rh1.dsc<br />publican_2.1-2.debian.tar.gz     publican_2.1-2rh1_i386.changes<br />publican_2.1-2.dsc               publican_2.1-2rh1_source.changes<br />publican_2.1-2rh1_all.deb        publican_2.1.orig.tar.gz<br />publican_2.1-2rh1.debian.tar.gz</code></div>

<h3 id='hakyll-convert-comments-title'>Comments (migrated from Blogger)</h3>
<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-23T20:09:15.543+02:00, Анонимный wrote:</p>
<p class='hakyll-convert-comment-body'>
&quot;Пакет исходников&quot; не? Или принципиально используется строгий оффициальный стиль?
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-23T20:33:07.888+02:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
Хех. Анонимус знает всё :) Действительно, можно было бы и так, тем более что для избежания постоянных повторов я скатывался даже до сленга («сорцы»). Впрочем, получилось неплохо, так что лично я смысла что–то менять не вижу. Или сто́ит–таки?
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-24T01:50:13.249+02:00, virens wrote:</p>
<p class='hakyll-convert-comment-body'>
@Анонимный<br />Кстати да, &quot;пакет исходников&quot; звучит краше. Я бы в посте поменял. Но пост и так хорош.<br /><br />@Minoru<br />Слушай, а в чём сакральный смысл apt-get source?<br />Я обычно тягаю исходники с домашней страницы авторов, потом dh_make --createorig и далее debuild. Чем не?<br /><br />И ещё. Можно многоуважаемого граммарфюрера попросить пройтись калёным железом <a href="http://mydebianblog.blogspot.com/2010/11/doxygen-matlab.html" rel="nofollow">по этому посту</a>? Там комментарий можно оставить даже, будешь, пардон, первонахом :-)<br /><br />Да, кстати, есть предложение собрать твои гармошки по ZSH в один большой баян + какие-нибудь неопубликованные заметки по ZSH и запостить у меня. Я сейчас в отпуске, так что время есть. Черкни чего-нибудь на mydebianblog жымайл ком, а то я твою почту что-то не найду.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-24T07:47:36.905+02:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
<b>&gt; Слушай, а в чём сакральный смысл apt-get source?<br />&gt; Я обычно тягаю исходники с домашней страницы авторов, потом dh_make --createorig и далее debuild. Чем не?</b><br /><br />Смысл в том, что после apt-get source ты получаешь исходники <i>пакета</i>. То есть если ты после этого сразу скажешь debuild, у тебя (теоретически) должен получиться точно такой же пакетик, что лежит в официальных репозиториях. Основное же преимущество такого подхода в том, что у тебя появляется уже работающий оформленный пакет, и всё, что тебе нужно — внести свои мелкие коррективы. Если же ты начинаешь с апстримового кода и dh_make, ты фактически самостоятельно создаёшь новый пакет. Это, по идее, круче и сложнее, но и проблем огрести можно.<br /><br /><b>&gt; И ещё. Можно многоуважаемого граммарфюрера попросить пройтись калёным железом по этому посту? Там комментарий можно оставить даже, будешь, пардон, первонахом :-)</b><br />Ой, Doxygen в Matlab&#39;е… Всё никак не доберусь до него. Вообще у меня тут как бы зачёты всё время, это вчера вот просто прорвало — услышал про патчик, живенько адаптировал под ту версию coreutils, что водится в наших сквизовских палестинах, собрал пакетик по руководству, ссылка на которое недавно по RSS прилетала — а потом взял да и написал обо всём этом. Ещё вот никак не доперевожу пост про dpatch — оно тоже с перепаковкой (да и сборкой с нуля тоже) связано.<br /><br />На мыло вечерком черкну, ок.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-25T05:53:43.371+02:00, virens wrote:</p>
<p class='hakyll-convert-comment-body'>
@Minoru<br /><br /><b> Вообще у меня тут как бы зачёты всё время, это вчера вот просто прорвало</b><br />Упс, извини, я совсем забыл. У меня сейчас обратная ситуация - я в отпуске :-) Университет закрыт на новогодние праздники до 5 января, сижу посты строчу (потом будет некогда), в комментах троллю :-)<br /><br />Ты там от зачётов не отвлекайся. Блог блогом, а зачёты - это серьёзно.<br /><br /><b>Ещё вот никак не доперевожу пост про dpatch — оно тоже с перепаковкой (да и сборкой с нуля тоже) связано.</b><br />Слушай, а ты попользуй scheduled posts. Удобственно: ставишь дату, скажем, в январе в настройках поста, и жмёшь &quot;Опубликовать пост&quot;. И всё - идёшь заниматься делами, а пост опубликуется без тебя. И провалов в датах не будет (в Октябре - ни одного поста, а в Декабре целых три подряд), и самому удобно.<br /><br />Я так уже давно пробавляюсь. Два поста в месяц - и обсудить успеваем, и мне не наряжно.<br /><br />И да, за комменты в Doxygen огромное спасибо - уже поправил.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-26T01:47:47.412+02:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
Отпуск — это классно! Приятного отдыха! ;)<br /><br />Scheduled posts я только для всяких поздравлений юзаю — всё остальное публикую сразу же. Просто не вижу смысла придерживать посты, если они уже готовы. Комментаторов у меня не так уж много, читателей всего полторы сотни (ну, плюс ещё runix — там поболее, конечно), так что я не боюсь быть заваленным почтой :) Да и в «провалах» ничего страшного не вижу — ну, не случилось ничего интересного, вот и не пишу.<br /><br />Тут ещё такое дело — однажды взявшись за написание постов раз в неделю, будет сложно от этой техники отказаться. Любой читатель твоего блога знает, что каждые две недели в понедельник он получит новую интересненькую статью. Мне почему–то не приходит в голову так много тем для постов, как тебе, так что мои читатели могут рассчитывать только на мои спонтанные всплески вдохновения.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-26T23:55:35.848+02:00, Paul Rufous wrote:</p>
<p class='hakyll-convert-comment-body'>
debuild - надстройка dpkg-buildpackage? Ключи те же.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-27T12:51:14.940+02:00, Minoru wrote:</p>
<p class='hakyll-convert-comment-body'>
<b>&gt; debuild - надстройка dpkg-buildpackage? Ключи те же.</b><br />И да, и нет. Да, debuild использует dpkg-buildpackage, но не только его. После сборки пакета запускаются lintian (проверка пакета на ошибки) и debsign.
</p>
</div>

<div class='hakyll-convert-comment'>
<p class='hakyll-convert-comment-date'>On 2010-12-28T03:08:28.542+02:00, virens wrote:</p>
<p class='hakyll-convert-comment-body'>
@Minoru комментирует...<br /><b>Просто не вижу смысла придерживать посты, если они уже готовы.</b><br />Смысл в том, чтобы поддерживать регулярную жизнь блога. Вот у меня, например, два поста в месяц, по понедельникам. Народ привык, мне удобно, и жизнь блога не обрывается - в каждом месяце есть посты.<br /><br />Это приводит к тому, что намного меньшее количество читателей отписываются, думая, что блог помер. <br /><br /><i>&quot;Но ты был не прав,<br />ты всё спалил за час,<br />и через час <br />большой огонь угас...&quot;</i><br /><br />Выкидывать кучу постов в один-два дня бессмысленно - ты потом не сможешь ничего написать долго и снова уйдёшь в тину. И без того немногочисленные читатели разбегутся, а новые, видя здоровенные прогалы в постинге, вряд ли подпишутся.<br /><br /><b>Комментаторов у меня не так уж много, читателей всего полторы сотни (ну, плюс ещё runix — там поболее, конечно), так что я не боюсь быть заваленным почтой</b><br />А ты подумай, почему их немного. Вот тебе пища для размышлений:<br />1. в постинге большие периоды затишья<br />2. названия постов плохо ищутся поисковыми машинами<br />3. часть постов слишком короткие, чтобы быть самостоятельными постами<br /><br /><br /><b>Да и в «провалах» ничего страшного не вижу - ну, не случилось ничего интересного, вот и не пишу.</b><br />Это точка зрения писателя. Теперь посмотри со стороны читателя. Вот ты зашёл на блог, а там четыре месяца ничего не пишут. В предыдущие месяцы по одному посту. Что ты подумаешь об этом? Блог помер. И не станешь подписываться на заведомо дохлый фид.<br /><br />Попробуй выкладывать посты регулярно - скажем, по средам. Два-три поста в месяц, с хорошим интервалом между ними. И посмотри на статистику подписчиков. Я готов поспорить, что их будет больше.<br /><br /><br /><b>Тут ещё такое дело — однажды взявшись за написание постов раз в неделю, будет сложно от этой техники отказаться.</b><br />Это слишком часто, как мне кажется. Я тут написал пост о десктопе. Это заняло ДВОЕ СУТОК. Но у меня есть время сейчас, потом его не будет. Именно поэтому, как ты уже видел у меня в dashboard, у меня посты расписаны на следующий год.<br /><br /><b>Любой читатель твоего блога знает, что каждые две недели в понедельник он получит новую интересненькую статью.</b><br />Справедливости ради, далеко не все они интересные.<br />А вот чего читатель блога не знает, так это то, что написаны они ЗАДОЛГО до появления. И появляются они дважды в неделю тогда, когда я занят другими вещами. Инода я забываю об этом и узнаЮ, что на моём блоге что-то опубликовано, по комментариям на почту :-)  <br /><br /><b>Мне почему-то не приходит в голову так много тем для постов, как тебе</b><br />Как говорили классики, &quot;достигается упражнением&quot;. Написать можно о чём угодно. Последний мой пост о Файрфоксе целиком стибрен со слешдота - с дополнениями и скриншотами, естественно. Или вот помнишь мой пост про монтирование разделов? Там есть что-нибудь, чего нет в man mount? Нет. А что там есть? Сбор и обобщение того, &quot;куды лошадь запрягать&quot;, с чётким описанием и хорошим оформлением. <br /><br />Посту не обязательно быть оригинальным в плане новизны. Хороший повар приготовит банальную яичницу так, что пальчики оближешь :-) Главное - как подать. <br /><br /><b>так что мои читатели могут рассчитывать только на мои спонтанные всплески вдохновения.</b><br />Они случаются не часто. Идея отложенных постов в том и состоит: разнести твоё вдохновение на максимально возможный срок. Сборка пакетов в Debian - это не обзор новой альфы Убунты. Подождёт месяцок и не протухнет.
</p>
</div>


