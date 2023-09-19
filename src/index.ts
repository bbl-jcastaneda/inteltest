import { registerPlugin } from '@capacitor/core';

import type { IntelTestPlugin } from './definitions';

const IntelTest = registerPlugin<IntelTestPlugin>('IntelTest', {
  web: () => import('./web').then(m => new m.IntelTestWeb()),
});

export * from './definitions';
export { IntelTest };
