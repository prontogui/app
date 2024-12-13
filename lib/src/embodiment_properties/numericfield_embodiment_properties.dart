import 'common_properties.dart';
import 'embodiment_property_help.dart';

class NumericFieldEmbodimentProperties with CommonProperties {
  String embodiment;

  static final Set<String> _validEmbodiments = {
    'default',
    'font-size',
    'color'
  };

  NumericFieldEmbodimentProperties.fromMap(Map<String, dynamic>? embodimentMap)
      : embodiment = getEnumStringProp(
            embodimentMap, 'embodiment', 'default', _validEmbodiments) {
    super.initializeFromMap(embodimentMap);
  }
}
