import { run } from 'static-base';
import { copy } from 'static-base-contrib';


export default function(data) {
  return run(
    [copy, 'build/images']
  )(
    'src/images/**/*',
    data.__root__
  );
}
