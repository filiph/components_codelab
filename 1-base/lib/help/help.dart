import 'package:angular2/core.dart';
import 'package:angular2/src/common/directives.dart';

@Component(
  selector: 'help-component',
  templateUrl: 'help.html',
  styleUrls: const ['help.css'],
  directives: const [
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
  ],
)
class HelpComponent {
  @Input()
  String content;
}
