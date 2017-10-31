note
	description: "Tests of {JV_RADIO_TOGGLE_BUTTON}"
	date: "$Date: 2014-05-13 14:52:00 -0400 (Tue, 13 May 2014) $"
	revision: "$Revision: 9162 $"
	testing: "type/manual"

class
	JV_RADIO_TOGGLE_BUTTON_TEST_SET

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

feature -- Tests

	test_radio_toggle_button
			-- Test toggling of {JV_RADIO_TOGGLE_BUTTON}.
		note
			testing:  "run/checkin/regular", "execution/isolated"
		local
			l_box: EV_HORIZONTAL_BOX
			l_button_1, l_button_2: JV_RADIO_TOGGLE_BUTTON
		do
				-- Creation
			create l_button_1
			create l_button_2
			create l_box
			l_box.extend (l_button_1)
			l_box.extend (l_button_2)
				-- Initial status
			assert ("button_1_not_selected_initially", not l_button_1.is_selected)
			assert ("button_2_not_selected_initially", not l_button_2.is_selected)
				-- Select button 1
			l_button_1.enable_select
			assert ("button_1_selected", l_button_1.is_selected)
			assert ("button_2_not_selected", not l_button_2.is_selected)
				-- Select button 2
			l_button_2.enable_select
			assert ("button_1_not_selected", not l_button_1.is_selected)
			assert ("button_2_selected", l_button_2.is_selected)
		end

	test_radio_toggle_button_with_specified_peers
			-- Test toggling of {JV_RADIO_TOGGLE_BUTTON} with specified peers.
		note
			testing:  "run/checkin/regular", "execution/isolated"
		local
			l_button_list: ARRAYED_LIST [JV_RADIO_TOGGLE_BUTTON]
			l_button_1, l_button_2: JV_RADIO_TOGGLE_BUTTON
		do
				-- Creation	
			create l_button_1
			create l_button_2
			create l_button_list.make (2)
			l_button_list.extend (l_button_1)
			l_button_list.extend (l_button_2)
			l_button_1.set_specified_peers (l_button_list)
			l_button_2.set_specified_peers (l_button_list)
				-- Initial status
			assert ("button_1_not_selected_initially", not l_button_1.is_selected)
			assert ("button_2_not_selected_initially", not l_button_2.is_selected)
				-- Select button 1
			l_button_1.enable_select
			assert ("button_1_selected", l_button_1.is_selected)
			assert ("button_2_not_selected", not l_button_2.is_selected)
				-- Select button 2
			l_button_2.enable_select
			assert ("button_1_not_selected", not l_button_1.is_selected)
			assert ("button_2_selected", l_button_2.is_selected)
		end

end
