import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'Classes/FCMProvider.dart';

List<SingleChildWidget> providers = <SingleChildWidget>[
    ...independentProviders
];
List<SingleChildWidget> independentProviders = <SingleChildWidget>[
  Provider<FCMProvider>.value(value: FCMProvider())
];