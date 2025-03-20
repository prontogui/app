// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:io';
import 'package:args/args.dart';
import 'package:dartlib/dartlib.dart';

class CmdLineOptions {
  // Default values for options
  static const defaultAddr = '127.0.0.1';
  static const defaultPort = '50053';
  var defaultPortInt = int.parse(defaultPort);
  var defaultServer = '$defaultAddr:$defaultPort';

  // Effective values for options after parsing and consideration of defaults.
  late final String serverAddr;
  late final int serverPort;
  late final LoggingLevel logLevel;

  CmdLineOptions.from(List<String> args) {
    // Parse the command-line args
    final parser = ArgParser()
      ..addOption('server',
          abbr: 's',
          defaultsTo: defaultServer,
          help: 'The address of the server with an optional [:port] specified.')
      ..addFlag('help',
          abbr: 'h',
          help: 'Display help on command-line options for this program.')
      ..addOption('loglevel',
          abbr: 'l',
          defaultsTo: 'warning',
          allowed: [
            'off',
            'fatal',
            'error',
            'warning',
            'info',
            'debug',
            'trace',
          ],
          help: 'Set the logging level for the program.');

    late ArgResults parsedArgs;

    /// Prints the command-line usage and options for this application.
    void printUsage(String message) {
      stdout.writeln('\n$message\n${parser.usage}');
    }

    try {
      parsedArgs = parser.parse(args);
    } catch (err) {
      printUsage('Invalid command line usage.');
      exit(-1);
    }

    String serverAddr = defaultAddr;
    int serverPort = defaultPortInt;

    var serverOption = parsedArgs.option('server');
    if (serverOption != null) {
      // Parse server option as addr:port
      var serverOptionParts = serverOption.split(':');

      if (serverOptionParts.length > 2) {
        printUsage('Invalid command line usage:  server option is invalid.');
        exit(-1);
      }

      serverAddr = serverOptionParts[0];

      if (serverOptionParts.length == 2) {
        var port = int.tryParse(serverOptionParts[1]);
        if (port == null) {
          printUsage('Invalid command line usage:  port must be a number.');
          exit(-1);
        }
        serverPort = port;
      }
    }

    var logLevelOption = parsedArgs['loglevel'];
    var logLevel = LoggingLevel.warning;
    switch (logLevelOption) {
      case 'off':
        logLevel = LoggingLevel.off;
      case 'fatal':
        logLevel = LoggingLevel.fatal;
      case 'error':
        logLevel = LoggingLevel.error;
      case 'warning':
        logLevel = LoggingLevel.warning;
      case 'info':
        logLevel = LoggingLevel.info;
      case 'debug':
        logLevel = LoggingLevel.debug;
      case 'trace':
        logLevel = LoggingLevel.trace;
      default:
        printUsage('Invalid command line usage:  loglevel is invalid.');
        exit(-1);
    }

    if (parsedArgs.flag('help')) {
      printUsage('Command line usage:');
      exit(0);
    }

    this.serverAddr = serverAddr;
    this.serverPort = serverPort;
    this.logLevel = logLevel;
  }
}
