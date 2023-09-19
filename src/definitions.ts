export interface IntelTestPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
