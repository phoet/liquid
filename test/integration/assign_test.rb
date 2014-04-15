require 'test_helper'

class AssignTest < Test::Unit::TestCase
  include Liquid

  def test_assigned_variable
    assert_template_result('.foo.',
                           '{% assign foo = values %}.{{ foo[0] }}.',
                           'values' => %w{foo bar baz})

    assert_template_result('.bar.',
                           '{% assign foo = values %}.{{ foo[1] }}.',
                           'values' => %w{foo bar baz})
  end

  def test_assign_with_filter
    assert_template_result('.bar.',
                           '{% assign foo = values | split: "," %}.{{ foo[1] }}.',
                           'values' => "foo,bar,baz")
  end

  def test_assign_syntax_error
    assert_match_syntax_error(/assign/,
                              '{% assign foo not values %}.',
                              'values' => "foo,bar,baz")
  end

  def test_dotted_variable
    template = "Original title: {{ page.title }}\n{% assign page.title = 'bar baz' %}\nNew title: {{ page.title }}"

    assert_template_result("Original title: foo\n\nNew title: foo", template, 'page' => {'title' => 'foo'})
  end
end
