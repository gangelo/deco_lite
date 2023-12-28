### 1.5.9 2023-12-27

* Changes
  * Update ruby gems

### 1.5.8 2023-12-02

* Changes
  * Update ruby gems

### 1.5.7 2023-10-30

* Changes
  * Update ruby gems

### 1.5.6 2023-10-30

* Changes
  * Update ruby gems

### 1.5.5

* Changes
  * Update ruby gems
  * Fix rubocop violations

### 1.5.4

* Changes
  * Update ruby gems

### 1.5.3
* Bugs
  * Fix bug that raised an exception when using `validates_with <Custom Validator>` because `#attributes` is not found on custom validators.
* Changes
  * You can now use `validates_with <Custom Validator>` by passing the attribute name(s) to your custom validator via the `#options` hash with a key of `:attributes` OR `:fields`. For example: `validates_with MyCustomValidator, attributes: %i[field1 field2]` of `validates_with MyCustomValidator, fields: %i[field1 field2]`
  * Updated README.md for the above change.
  * Update bundled gems.
### 1.5.2
* Changes
  * Update ruby gems. Remedy activesupport dependabot alert.

### 1.5.1
* Changes
  * Update ruby gems.

### 1.5.0
* Changes
  * Update ruby gems.

### 1.4.0
* Changes
  * Required ruby version is now '~> 3.0'
  * Prohibit SimpleCov from starting 2x in spec_helper.rb.

### 1.3.0
* Changes
  * Update gem description in .gemspec.

### 1.2.1
* Bugs
  * Fix bug that did not recognize loaded field values if `attr_accessors` were previously created for the loaded fields due to model validations being present. If `ActiveModel` validators are present on the model, DecoLite will automatically create `attr_accessors` for the fields associated with the validations. The presence of these fields being automatically loaded prohibited any fields subsequently loaded having the same field names to not be recognized as having been loaded, causing validation to validate incorrectly (the model did not recognize the fields as having been loaded).
  * Fix bug that wiped out field values previously loaded if `ActiveModel` validations were present for fields having the same name. This is because DecoLite will automatically create `attr_accessors` for the fields associated with the validations, initializing these automatically created field vars to be initialized to nil. The auto-creation of these `attr_accessors` was taking place in #initialize AFTER the initial load of any Hash passed to #initialize in the :hash param, so the values loaded were getting nilled out.
* Changes
  * Add specs to test the above scenarios.

### 1.2.0
* Changes
  * Update the README.md file with better explainations and examples.

### 1.1.0
* Changes
  * Update mad_flatter gem to v2.0.0.

### 1.0.0
* Breaking changes
  * Removed `FieldRequireable` and moved this code to the `Model` class because determination of required fields loaded is now determined in the `Model` class, rather than checking the existance of model attributes.
  * Removed `RequiredFieldsOptionable` since determination of whether or not required fields were loaded no longer depends on the existance of model attributes, this option was removed. `Model#required_fields` model attributes can now be created unconditionally, and still determine whether or not reqired fields were loaded or not.
  * Since `FieldRequireable` has been removed, along with `#required_fields`, the `Model#required_fields` can now be overridden or manipulated to designate required fields. Required fields will cause validtion to fail if those fields are not loaded into the model like before.
  * The reason for the aforementioned changes is that the whole paradigm to validate "required fields" (i.e. fields required when loading a Hash) based on model attributes introduced complexity/awkwardness in using the `DecoLite::Model` class, as well as complexity in the `DecoLite` codebase. These changes makes things simpler and cleaner.
  * Remove deprecated `DecoLite::Model#load`. Use `DecoLite::Model#load!` instead.
* Changes
  * Update README.md file accordingly.

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
