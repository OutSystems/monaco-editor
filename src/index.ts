import { css, html, json, typescript } from './languages/register.all';
import './features/register.all';

// ensure that the the main monaco-editor entry-point loads all features from monaco-editor-core
import 'monaco-editor-core';

export * from './editor';
export { css, html, json, typescript };
