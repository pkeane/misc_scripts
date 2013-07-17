#!/usr/bin/php
<?php

$projects_file = '/home/pkeane/Outlines/projects.otl';
$dom = new DOMDocument('1.0');
$dom->formatOutput = true;
$list = $dom->appendChild($dom->createElement('ul'));
$list->setAttribute('id','collapse');
$fh = fopen($projects_file,'r');
while (! feof($fh)) {
	$line = fgets($fh);
	if (preg_match('/^[^\t]/',$line)) {
		unset ($actions);
		$project = $list->appendChild($dom->createElement('li'));
		$project->appendChild($dom->createTextNode(trim($line)));
	}
	if (preg_match('/^\t[^\t]/',$line)) {
		unset($tasks);
		if (!$actions) {
			$actions = $project->appendChild($dom->createElement('ul'));
			$actions_count = 0;
			$actions->setAttribute('class','actions');
		}
		$actions_count++;
		$action_item = $actions->appendChild($dom->createElement('li'));
		$action_item->appendChild($dom->createTextNode(trim($line)));
		$actions->setAttribute('count',$actions_count);
	}
	if (preg_match('/^\t\t[^\t]/',$line)) {
		if (!$tasks) {
			$tasks = $action_item->appendChild($dom->createElement('ul'));
			$tasks_count = 0;
			$tasks->setAttribute('class','tasks');
		}
		$tasks_count++;
		$task_item = $tasks->appendChild($dom->createElement('li'));
		$task_item->appendChild($dom->createTextNode(trim($line)));
		$tasks->setAttribute('count',$tasks_count);
	}
}
echo $dom->saveHTML();

