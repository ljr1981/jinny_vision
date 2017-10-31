note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2015-07-29 14:20:13 -0400 (Wed, 29 Jul 2015) $"
	revision: "$Revision: 11873 $"
	testing: "type/manual"

class
	JV_CALENDAR_TEST_SET

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

feature -- Test routines

	test_calendar
			-- New test routine
		note
			testing:  "execution/isolated", "execution/serial"
		local
			l_date_field: JV_DATE_FIELD
			l_calendar: JV_CALENDAR_MONTH
			l_week: JV_CALENDAR_WEEK
		do
			create l_date_field.make_with_date (create {DATE}.make (2014, 6, 15))
			create l_calendar.make_with_date_field (l_date_field, agent l_date_field.set_date, agent (create {EV_POPUP_WINDOW}).destroy_and_exit_if_last)
			assert_strings_equal ("is_june", "June", l_calendar.month_name)
			assert_strings_equal ("is_2014", "2014", l_calendar.year_name)
			l_week := l_calendar.week_2
			l_week.on_click (0,0,0,0.0,0.0,0.0,0,0, create {DATE}.make (2015, 10, 21), l_date_field, agent do_nothing)
			assert_strings_equal ("date_field_updated", "10/21/2015", l_date_field.text)
		end

end


