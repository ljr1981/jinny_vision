note
	description: "Tests of {JV_DATE_FIELD}"
	date: "$Date: 2016-01-19 15:13:59 -0500 (Tue, 19 Jan 2016) $"
	revision: "$Revision: 13013 $"
	testing: "type/manual"

class
	JV_DATE_FIELD_TEST_SET

inherit
	EXTENDED_TEST_SET

feature -- Tests

	test_mouse_scroll
			-- Test mouse scroll handling.
		note
			testing:  "run/checkin/regular", "execution/isolated"
		local
			l_field: JV_DATE_FIELD
			l_date: DATE
		do
				-- Creation
			create l_field
				-- Testing empty field
			l_field.on_mouse_wheel (1)
				-- Testing date changes
			create l_date.make (2015, 10, 21)
			l_field.set_date (l_date)
			assert_strings_equal ("date_in_field_initially", "10/21/2015", l_field.text)
			l_field.on_mouse_wheel (1)
			assert_strings_equal ("date_in_field_after_scrolling_up", "11/21/2015", l_field.text)
			l_field.on_mouse_wheel (-1)
			assert_strings_equal ("date_in_field_after_scrolling_down", "10/21/2015", l_field.text)
				-- Testing scrolling back from year 0
			create l_date.make (0000, 1, 1)
			l_field.set_date (l_date)
			l_field.on_mouse_wheel (-1)
			assert_strings_equal ("date_in_field_after_scrolling_down_from_year_0000", "01/01/0000", l_field.text)
				-- Testing scrolling up from year 9999
			create l_date.make (9999, 12, 31)
			l_field.set_date (l_date)
			l_field.on_mouse_wheel (1)
			assert_strings_equal ("date_in_field_after_scrolling_up_from_year_9999", "12/31/9999", l_field.text)
		end

	test_date
			-- Tests return of {DATE} object from field.
		note
			testing:  "run/checkin/regular", "execution/isolated"
		local
			l_field: JV_DATE_FIELD
			l_date: DATE
		do
				-- Creation
			create l_field
				-- Testing date changes
			create l_date.make (1955, 11, 05)
			l_field.set_date (l_date)
			assert_strings_equal ("date_in_field", "11/05/1955", l_field.text)
			assert_equals ("date_from_field_matches_original_date", l_date, l_field.date)
		end

end
