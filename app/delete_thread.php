<?php
if (requirelogin())
    return;

list($tid) = $args;

$thread = fetchone('fid, tid, attachment FROM threads WHERE tid = ? LIMIT 1', $tid);
if (delete('threads', array('tid = ? AND uid = ?', $tid, $my->uid), 1)) {
    @unlink(ROOT . "/www/attachment/$thread->tid-$thread->attachment");
    redirect('forum', $thread->fid);
}
nocontent();
