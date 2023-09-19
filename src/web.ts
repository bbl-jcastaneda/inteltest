import { WebPlugin } from '@capacitor/core';

import type { IntelTestPlugin } from './definitions';

export class IntelTestWeb extends WebPlugin implements IntelTestPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
