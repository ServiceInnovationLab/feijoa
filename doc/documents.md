## Adding a new type of document

1. Include the `document` concern

```
# models/cool_document.rb
class CoolDocument < ApplicationRecord
  include Document
  ...
```

2. Add the document type to the list of document types

```
# models/concerns/document.rb
module Document
  extend ActiveSupport::Concern
  IMMUNISATION_RECORD = 'ImmunisationRecord'
  BIRTH_RECORD = 'BirthRecord'
  COOL_DOCUMENT = 'CoolDocument'
  DOCUMENT_TYPES = [IMMUNISATION_RECORD, BIRTH_RECORD, COOL_DOCUMENT].freeze
  ...
  def cool_document?
    document_type == COOL_DOCUMENT
  end
```

3. Add the shared examples to your spec

```
# spec/models/cool_document_spec.rb

RSpec.describe CoolDocument, type: :model do
  let(:document) { FactoryBot.create(:cool_document) }
  it_behaves_like 'a document'
  ...
```

4. Override any methods you want to override

```
# models/cool_document.rb
class CoolDocument < ApplicationRecord
  include Document
  def title
    "#{name} (#{coolness_rating})"
  end
```

5. Create a partial for how your document should be rendered

```
# views/shared/documents/_cool_document.html.erb
<dl>
  <dt>Name</dd>
  <dd><%= cool_document.name %></dd>
  <dt>Coolness rating</dt>
  <dd><%= cool_document.coolness_rating %></dd>
</dl>
```

This will allow the document type to be requested and shared. 
