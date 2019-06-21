# frozen_string_literal: true

# This service provides convenience functions on the application data which
# shouldn't be allowed in a production application
class DemoDataService
  DEFAULT_ADULT_BIRTHDAY = Date.parse('1980-01-01').freeze
  DEFAULT_CHILD_BIRTHDAY = Date.parse('2010-01-01').freeze

  # Creates a birth record for the specified names, born on 1 January 1980 (random sex) so
  # it's easy to search for
  def self.create_birth_record(first_and_middle_names, family_name)
    FactoryBot.create(
      :birth_record,
      first_and_middle_names: first_and_middle_names,
      family_name: family_name,
      date_of_birth: DEFAULT_ADULT_BIRTHDAY
    )
  end

  # Create birth records representing a nuclear family assuming an existing adult:
  # - 1 additional parent named Matua <family_name> born on 1 January 1980 (random sex)
  # - 1 child named Tama <family_name> born on 1 January 2010 (male)
  # - 1 child named Hine <family_name> born on 1 January 2010 (female)
  def self.create_family_birth_records(family_name)
    create_birth_record('Matua', family_name)

    FactoryBot.create(
      :birth_record,
      first_and_middle_names: 'Tama',
      family_name: family_name,
      date_of_birth: DEFAULT_CHILD_BIRTHDAY,
      sex: 'Male'
    )

    FactoryBot.create(
      :birth_record,
      first_and_middle_names: 'Hine',
      family_name: family_name,
      date_of_birth: DEFAULT_CHILD_BIRTHDAY,
      sex: 'Female'
    )
  end
end
