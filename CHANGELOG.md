### 0.3.2
* Changes
  * Refactor FieldAssignable to remove call to FieldCreatable#create_field_accessor as this breaks single responsibility rule; which, in this case, makes sense to remove. FieldCreatable#create_field_accessor can be called wherever creation of a attr_accessor is needed.
  * Refactor specs in keeping with above changes.
  * README.md changes.
* Bugs
  * Fix bug where loading fields with the options: { fields: :strict } option raises an error for field that already exists.

### 0.3.1
* Changes
  * Added `DecoLite::FieldRequireable::MISSING_REQUIRED_FIELD_ERROR_TYPE` for required field type errors.
  * Update README.md with more examples.

### 0.3.0
* Changes
  * `DecoLite::Model#new` how accepts a :hash named parameter that will load the Hash as if calling `DecoLite::Model.new.load!(hash: <hash>)`.
  * `DecoLite::Model#new now creates attr_accessors (fields) for any attribute that has an ActiveModel validator associated with it. This prevents errors raised when #validate is called before data is #load!ed.
  * `DecoLite::Model#new` now creates attr_accessors (fields) for any field returned from `DecoLite::Model#reqired_fields` IF the required_fields: :auto option is set.
  * bin/console now starts a pry-byebug session.

### 0.2.5
* Changes
  * Remove init of `@field_names = []` in `Model#initialize` as unnecessary - FieldNamesPersistable takes care of this.
* Bug fixes
  * Fix but that does not take into account option :namespace when determining whether or not a field name conflicts with an existing attribute (already exists).

### 0.2.4
* Changes
  * Change DecoLite::Model#load to #load! as it alters the object, give deprecation warning when calling #load.
  * FieldConflictable now expliticly prohibits loading fields that conflict with attributes that are native to the receiver. In other words, you cannot load fields with names like :to_s, :tap, :hash, etc.
  * FieldCreatable now creates attr_accessors on the instance using #define_singleton_method, not at the class level (i.e. self.class.attr_accessor) (see bug fixes).
* Bug fixes
  * Fix bug that used self.class.attr_accessor in DecoLite::FieldCreatable to create attributes, which forced every object of that class subsequently created have the accessors created which caused field name conflicts across DecoLite::Model objects.

### 0.2.3
* Bug fixes
  * Fix bug that added duplcate field names to Model#field_names.

### 0.2.2
* Bug fixes
  * Fix bug requiring support codez in lib/deco_lite.rb.

### 0.2.1
* Changes
  * Add mad_flatter gem runtime dependency.
  * Refactor to let mad_flatter handle the Hash flattening.

### 0.1.1
* Changes
  * Update gems and especially rake gem version to squash CVE-2020-8130, see https://github.com/advisories/GHSA-jppv-gw3r-w3q8.
  * Fix rubocop violations.

### 0.1.0
* Initial commit
