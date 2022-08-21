### 0.2.4
* Changes
  * Change DecoLite::Model#load to #load! as it alters the object, give deprecation warning when calling #load.
  * FieldConflictable now expliticly prohibits loading fields that conflict with attributes that are native to the receiver. In other words, you cannot load fields with names like :to_s, :tap, :hash, etc.
  * FieldCreatable now creates attr_accessors on the instance using #define_singleton_method, not at the class level (i.e. self.class.attr_accessor) (see bug fixes).
* bug fixes
  * Fix bug that used self.class.attr_accessor in DecoLite::FieldCreatable to create attributes, which forced every object of that class subsequently created have the accessors created which caused field name conflicts across DecoLite::Model objects.

### 0.2.3
* Fix bug that added duplcate field names to Model#field_names.

### 0.2.2
* Fix bug requiring support codez in lib/deco_lite.rb.

### 0.2.1
* changes
  * Add mad_flatter gem runtime dependency.
  * Refactor to let mad_flatter handle the Hash flattening.

### 0.1.1
* changes
  * Update gems and especially rake gem version to squash CVE-2020-8130, see https://github.com/advisories/GHSA-jppv-gw3r-w3q8.
  * Fix rubocop violations.

### 0.1.0
* Initial commit