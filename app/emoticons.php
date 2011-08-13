<?php
if (requirelogin())
    return;

if ($_FILES && $_FILES['emoticon']['size'] <= 100 << 10) {
    move_uploaded_file(
        $_FILES['emoticon']['tmp_name'],
        ROOT . '/www/emo/' . basename($_FILES['emoticon']['name']));
}
?>
<h2>이모티콘</h2>

<form method=post enctype=multipart/form-data>
<p><input type=file name=emoticon><input type=submit value="올리기"></p>
</form>

<ul class=emoticons>
<?php
foreach (glob(ROOT . '/www/emo/*') as $path):
    $name = preg_replace('#\.[^.]*$#s', '', basename($path));
?>
<li><a href="<?= u(emo, $name) ?>"><?= h($name) ?></a>
<?php endforeach ?>
</ul>
