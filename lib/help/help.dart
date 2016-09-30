import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';
import 'package:angular2_components/angular2_components.dart';

@Component(
  selector: 'help-component',
  templateUrl: 'help.html',
  styleUrls: const ['help.css'],
  directives: const [
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    materialDirectives
  ],
)
class HelpComponent {
  @Input()
  String content;
}
