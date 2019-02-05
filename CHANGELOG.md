### 0.1.0
  * Added the `envy-scene` Angular component and removed `envy-div` Polymer component.
  * Upgraded dependencies; removed explicit dependencies on `reflectable` and `web_components`.

### 0.0.7
  * Only update line dash value when necessary
  * Upgraded to `polymer 1.0.0-rc.14`, `polymer-elements 1.0.0-rc.7` and `reflectable 0.5.1`
  * __+1__: Clear intersection indices for every child; improve intersection efficiency

### 0.0.6
  * Added a default line dash value
  * Added `GeoJson` support

### 0.0.5
  * Optimization of `EnvyProperty.updateValues`
  * Refined `CanvasNode` support for mouse enter, leave, over, out and move
  * Added `Sum`, `Diff`, `Product` and various other operation type NumberSources
  * Added support for dashed lines
  
### 0.0.4
  * `EnvyProperty.updateValues` no longer includes unavailable data when finishing
  * Bumped `polymer` dependency to `^1.0.0-rc.4`
  * Added `NakedProperty`, an `EnvyProperty` that makes its private values available 

### 0.0.3
  * Removed null operator ambiguity

### 0.0.2
  * Migrated to `polymer 1.0.0-rc.2`

### 0.0.1
  * Initial version