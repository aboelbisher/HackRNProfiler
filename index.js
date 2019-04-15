/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';

// global.nativeTraceBeginSection = function(a, b, c) {
//
// };

AppRegistry.registerComponent(appName, () => App);
