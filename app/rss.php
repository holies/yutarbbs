<?php

$threads = fetchall('fid, tid, subject, year, name, UNIX_TIMESTAMP(created_at) created, message FROM threads INNER JOIN users USING (uid) ORDER BY created_at DESC LIMIT 20');

$rss = new SimpleXMLElement(
        '<?xml version="1.0" encoding="UTF-8"?><rss version="2.0"/>');
$chan = $rss->addChild('channel');
$chan->addChild('title', 'yutar.net');
$chan->addChild('link', url());
$chan->addChild('description', 'yutar.net');
foreach ($threads as $t) {
    $item = $chan->addChild('item');
    $item->addChild('title', "[{$FORUM_NAME[$t->fid]}] $t->subject");
    $item->addChild('link', url('thread', $t->tid));
    $item->addChild('description', nl2br(formattext($t->message)));
	$item->addChild('author', "$t->year$t->name");
	$item->addChild('pubDate', date('r', $t->created));
	//$item->addChild('category', $FORUM_NAME[$t->fid]);
}

header('Content-Type: application/rss+xml');
echo $rss->asXML();
exit(0);
