library dumprendertree;

import 'package:hop/hop.dart';
import 'dart:io';
import 'dart:async';

main(List<String> args) {
	addTask('test', createUnitTestTask());
	runHop(args);
}

Task createUnitTestTask() {
	return new Task((TaskContext tcontext) {
		tcontext.info("Running Unit Tests....");
		var result = Process.run('./drt-lucid64-full-stable-45692.0/content_shell',
		['--dump-render-tree','test/mainpage_test.html'])
		.then((ProcessResult process) {
			tcontext.info(process.stdout);
		});
		return result;
	});
}