note
	description: "Test for {JV_GRID}"
	date: "$Date: 2014-08-05 10:34:44 -0400 (Tue, 05 Aug 2014) $"
	revision: "$Revision: 9654 $"
	testing: "type/manual"

class
	JV_GRID_TEST

inherit
	EXTENDED_TEST_SET
		redefine
			on_prepare
		end

	EV_KEY_CONSTANTS
		undefine
			default_create
		end

feature -- Tests

	test_grid_single_row_selection
				-- Test JV_GRID with single row selection enabled.
		note
			testing:  "run/checkin/regular", "execution/isolated"
		local
			l_window: EV_TITLED_WINDOW
			l_virtual_x_position: INTEGER
			l_subrow: EV_GRID_ROW
		do
			create l_window
			create grid
			grid.set_minimum_size (300, 300)

				-- Default grid settings
			assert ("default_is_single_item_selection", grid.is_single_item_selection_enabled)
			assert_equals ("default_no_columns", 0, grid.column_count)
			assert_equals ("default_no_rows", 0, grid.row_count)

			grid.enable_single_row_selection
			assert_equals ("default_is_single_row_selection", True, grid.is_single_row_selection_enabled)

				-- Populate grid with 3,000 items
			add_items (10, 300)
			grid.enable_tree
			add_subrows
			assert_equals ("has_10_columns", 10, grid.column_count)
			assert_equals ("has_300_rows", 300, grid.row_count)
			assert_equals ("has_150_visible_rows", 150, grid.visible_row_count)

			l_window.extend (grid)
			l_window.show
			l_window.raise
			grid.show
			grid.set_focus

				-- Expand all subrows
			expand_subrows

				-- Page Up/Down
				-- 1. Initial values
			assert_equals ("1_15_viewable_rows", 15, grid.viewable_row_count)
			assert_equals ("1_300_visible_rows", 300, grid.visible_row_count)
			assert_equals ("1_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("1_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("1_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("1_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			assert ("1_no_row_selected", not grid.has_selected_row)
			grid.select_row (1)
			assert ("1_has_row_selected", grid.has_selected_row)
			assert ("1_row_1_selected", grid.row (1).is_selected)
			assert_equals ("1_vertical_scroll_bar_position_top", proportion_top_left, grid.vertical_scroll_bar.proportion)
			assert_equals ("1_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 2. After page down.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			assert_equals ("2_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("2_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("2_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("2_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			assert ("2_row_14_selected", grid.row (14).is_selected)
			assert_equals ("2_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 3. After page down again.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			assert_equals ("3_row_13_is_first_visible", grid.row (13), grid.first_visible_row)
			assert_equals ("3_row_14_is_first_fully_visible", grid.row (14), grid.first_fully_visible_row)
			assert_equals ("3_row_27_is_fully_visible", grid.row (27), grid.last_fully_visible_row)
			assert_equals ("3_row_28_is_partially_visible", grid.row (28), grid.last_visible_row)
			assert ("3_row_27_selected", grid.row (27).is_selected)
			assert_equals ("3_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 4. After ctrl + page down
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			application.set_is_control_key_pressed (False)
			assert_equals ("4_row_287_is_first_visible", grid.row (287), grid.first_visible_row)
			assert_equals ("4_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("4_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("4_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			assert ("4_row_300_selected", grid.row (300).is_selected)
			assert_equals ("4_vertical_scroll_bar_position_bottom", proportion_bottom_right, grid.vertical_scroll_bar.proportion)
			assert_equals ("4_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 5. After page up
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_up))
			assert_equals ("5_row_287_is_first_visible", grid.row (287), grid.first_visible_row)
			assert_equals ("5_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("5_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("5_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			assert ("5_row_287_selected", grid.row (287).is_selected)
			assert_equals ("5_vertical_scroll_bar_position_bottom", proportion_bottom_right, grid.vertical_scroll_bar.proportion)
			assert_equals ("5_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 6. After page up again.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_up))
			assert_equals ("6_row_274_is_first_visible", grid.row (274), grid.first_visible_row)
			assert_equals ("6_row_274_is_first_fully_visible", grid.row (274), grid.first_fully_visible_row)
			assert_equals ("6_row_287_is_fully_visible", grid.row (287), grid.last_fully_visible_row)
			assert_equals ("6_row_288_is_partially_visible", grid.row (288), grid.last_visible_row)
			assert ("6_row_274_selected", grid.row (274).is_selected)
			assert_equals ("6_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				--| 7. After ctrl + page up
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_up))
			application.set_is_control_key_pressed (False)
			assert_equals ("7_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("7_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("7_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("7_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			assert ("7_row_1_selected", grid.row (1).is_selected)
			assert_equals ("7_vertical_scroll_bar_position_top", proportion_top_left, grid.vertical_scroll_bar.proportion)
			assert_equals ("7_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- Home/End
				-- 8. After end.
			assert_equals ("8_vertical_scroll_bar_position_left", proportion_top_left, grid.vertical_scroll_bar.proportion)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_end))
			assert_equals ("8_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("8_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("8_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("8_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			assert ("8_row_1_selected", grid.row (1).is_selected)
			assert_equals ("8_vertical_scroll_bar_position_top", proportion_top_left, grid.vertical_scroll_bar.proportion)
			assert_equals ("8_horizontal_scroll_bar_position_right", proportion_bottom_right, grid.horizontal_scroll_bar.proportion)
			l_virtual_x_position := grid.column (1).virtual_x_position
			assert ("8_first_column_not_shown", l_virtual_x_position < grid.virtual_x_position)
			l_virtual_x_position := grid.column (grid.column_count).virtual_x_position
			assert ("8_last_column_shown", l_virtual_x_position <= grid.virtual_x_position + grid.viewable_width)

				-- 9. After ctrl + page down
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			application.set_is_control_key_pressed (False)
			assert_equals ("9_row_287_is_first_visible", grid.row (287), grid.first_visible_row)
			assert_equals ("9_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("9_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("9_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			assert ("9_row_300_selected", grid.row (300).is_selected)
			assert_equals ("9_vertical_scroll_bar_position_bottom", proportion_bottom_right, grid.vertical_scroll_bar.proportion)
			assert_equals ("9_horizontal_scroll_bar_position_right", proportion_bottom_right, grid.horizontal_scroll_bar.proportion)

				-- 10. After home
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			assert_equals ("10_row_287_is_first_visible", grid.row (287), grid.first_visible_row)
			assert_equals ("10_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("10_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("10_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			assert ("10_row_300_selected", grid.row (300).is_selected)
			assert_equals ("10_vertical_scroll_bar_position_bottom", proportion_bottom_right, grid.vertical_scroll_bar.proportion)
			assert_equals ("10_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)
			assert ("10_first_column_shown", grid.column (1).virtual_x_position = grid.virtual_x_position)
			assert ("10_last_column_not_shown", grid.column (grid.column_count).virtual_x_position > grid.virtual_x_position + grid.viewable_width)

				-- 11. After ctrl + page up
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_up))
			application.set_is_control_key_pressed (False)
			assert_equals ("11_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("11_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("11_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("11_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			assert ("11_row_1_selected", grid.row (1).is_selected)
			assert_equals ("11_vertical_scroll_bar_position_top", proportion_top_left, grid.vertical_scroll_bar.proportion)
			assert_equals ("11_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 12. Select row 42
			grid.select_row (42)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			assert_equals ("12_row_28_is_first_visible", grid.row (28), grid.first_visible_row)
			assert_equals ("12_row_29_is_first_fully_visible", grid.row (29), grid.first_fully_visible_row)
			assert_equals ("12_row_42_is_fully_visible", grid.row (42), grid.last_fully_visible_row)
			assert_equals ("12_row_43_is_partially_visible", grid.row (43), grid.last_visible_row)
			assert ("12_row_42_selected", grid.row (42).is_selected)
			assert_equals ("12_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 13. After ctrl + end
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_end))
			application.set_is_control_key_pressed (False)
			assert_equals ("13_row_286_is_first_visible", grid.row (286), grid.first_visible_row)
			assert_equals ("13_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("13_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("13_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			assert ("13_row_300_selected", grid.row (300).is_selected)
			assert_equals ("13_horizontal_scroll_bar_position_right", proportion_bottom_right, grid.horizontal_scroll_bar.proportion)

				-- Select row 42 again
			grid.select_row (42)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_end))
				-- 14. After ctrl + home
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			application.set_is_control_key_pressed (False)
			assert_equals ("14_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("14_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("14_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("14_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			assert ("14_row_1_selected", grid.row (1).is_selected)
			assert_equals ("14_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 15. Hide last column and test navigation
			grid.column (grid.column_count).hide
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_end))
			l_virtual_x_position := grid.column (1).virtual_x_position
			assert ("15_first_column_not_shown", l_virtual_x_position < grid.virtual_x_position)
			assert ("15_last_column_not_shown", not grid.column (grid.column_count).is_show_requested)
			l_virtual_x_position := grid.column (grid.column_count - 1).virtual_x_position
			assert ("15_next_to_last_column_shown", grid.virtual_x_position <= l_virtual_x_position and l_virtual_x_position <=  grid.virtual_x_position + grid.viewable_width)
			grid.column (grid.column_count).show

				-- 16. Hide first column and test navigation
			grid.column (1).hide
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			assert ("16_first_column_not_shown", not grid.column (1).is_show_requested)
			l_virtual_x_position := grid.column (2).virtual_x_position
			assert ("16_second_column_shown", grid.virtual_x_position <= l_virtual_x_position and l_virtual_x_position <=  grid.virtual_x_position + grid.viewable_width)
			assert ("16_last_column_not_shown", grid.column (grid.column_count).virtual_x_position > grid.virtual_x_position + grid.viewable_width)
			grid.column (1).show

				-- 17. Select row 4, check that it's a subrow, hide it, perform calcs based on hidden row.
			l_subrow := grid.row (4)
			assert ("17_row_4_has_parent_row", attached l_subrow.parent_row)
			check attached l_subrow.parent_row as al_parent_row then
				al_parent_row.collapse
				assert ("17_row_4_hidden", not al_parent_row.is_expanded)
			end
			assert_equals ("1_299_visible_rows", 299, grid.visible_row_count)
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			application.set_is_control_key_pressed (False)
			assert_equals ("17_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("17_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("17_row_15_is_fully_visible", grid.row (15), grid.last_fully_visible_row)
			assert_equals ("17_row_16_is_partially_visible", grid.row (16), grid.last_visible_row)

				-- 18. After page down.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			assert_equals ("18_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("18_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("18_row_15_is_fully_visible", grid.row (15), grid.last_fully_visible_row)
			assert_equals ("18_row_16_is_partially_visible", grid.row (16), grid.last_visible_row)
			assert ("18_row_15_selected", grid.row (15).is_selected)

				-- 19. After page down again.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			assert_equals ("19_row_14_is_first_visible", grid.row (14), grid.first_visible_row)
			assert_equals ("19_row_15_is_first_fully_visible", grid.row (15), grid.first_fully_visible_row)
			assert_equals ("19_row_28_is_fully_visible", grid.row (28), grid.last_fully_visible_row)
			assert_equals ("19_row_29_is_partially_visible", grid.row (29), grid.last_visible_row)
			assert ("19_row_28_selected", grid.row (28).is_selected)
		end

	test_grid_single_item_selection
				-- Test JV_GRID with single item selection enabled.
		note
			testing:  "run/checkin/regular", "execution/isolated"
		local
			l_window: EV_TITLED_WINDOW
			l_item: EV_GRID_ITEM
			l_virtual_x_position: INTEGER
			l_subrow: EV_GRID_ROW
		do
			create l_window
			create grid
			grid.set_minimum_size (300, 300)

				-- Default grid settings
			assert ("default_is_single_item_selection", grid.is_single_item_selection_enabled)
			assert_equals ("default_no_columns", 0, grid.column_count)
			assert_equals ("default_no_rows", 0, grid.row_count)

				-- Populate grid with 3,000 items
			add_items (10, 300)
			grid.enable_tree
			add_subrows
			assert_equals ("has_10_columns", 10, grid.column_count)
			assert_equals ("has_300_rows", 300, grid.row_count)
			assert_equals ("has_150_visible_rows", 150, grid.visible_row_count)

			l_window.extend (grid)
			l_window.show
			l_window.raise
			grid.show
			grid.set_focus

				-- Expand all subrows
			expand_subrows

				-- Page Up/Down
				-- 1. Initial values
			assert_equals ("1_15_viewable_rows", 15, grid.viewable_row_count)
			assert_equals ("1_300_visible_rows", 300, grid.visible_row_count)
			assert_equals ("1_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("1_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("1_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("1_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			assert ("1_no_item_selected", not grid.has_selected_item)
			grid.select_item (3, 1)		-- col 3, row 1
			check selected_item_1: attached grid.item (3, 1) as al_item then
				l_item := al_item
			end
			assert ("1_has_item_selected", grid.has_selected_item)
			assert ("1_item_3_1_selected", l_item.is_selected)
			assert_equals ("1_vertical_scroll_bar_position_top", proportion_top_left, grid.vertical_scroll_bar.proportion)
			assert_equals ("1_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 2. After page down.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			assert_equals ("2_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("2_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("2_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("2_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			check selected_item_2: attached grid.item (3, 14) as al_item then
				l_item := al_item
			end
			assert ("2_item_3_14_selected", l_item.is_selected)
			assert_equals ("2_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 3. After page down again.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			assert_equals ("3_row_13_is_first_visible", grid.row (13), grid.first_visible_row)
			assert_equals ("3_row_14_is_first_fully_visible", grid.row (14), grid.first_fully_visible_row)
			assert_equals ("3_row_27_is_fully_visible", grid.row (27), grid.last_fully_visible_row)
			assert_equals ("3_row_28_is_partially_visible", grid.row (28), grid.last_visible_row)
			check selected_item_1: attached grid.item (3, 27) as al_item then
				l_item := al_item
			end
			assert ("3_item_3_27_selected", l_item.is_selected)
			assert_equals ("2_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 4. After ctrl + page down
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			application.set_is_control_key_pressed (False)
			assert_equals ("4_row_287_is_first_visible", grid.row (287), grid.first_visible_row)
			assert_equals ("4_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("4_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("4_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			check selected_item_1: attached grid.item (3, 300) as al_item then
				l_item := al_item
			end
			assert ("4_item_3_300_selected", l_item.is_selected)
			assert_equals ("4_vertical_scroll_bar_position_bottom", proportion_bottom_right, grid.vertical_scroll_bar.proportion)
			assert_equals ("4_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 5. After page up
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_up))
			assert_equals ("5_row_287_is_first_visible", grid.row (287), grid.first_visible_row)
			assert_equals ("5_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("5_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("5_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			check selected_item_1: attached grid.item (3, 287) as al_item then
				l_item := al_item
			end
			assert ("5_item_3_287_selected", l_item.is_selected)
			assert_equals ("5_vertical_scroll_bar_position_bottom", proportion_bottom_right, grid.vertical_scroll_bar.proportion)
			assert_equals ("5_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 6. After page up again.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_up))
			assert_equals ("6_row_274_is_first_visible", grid.row (274), grid.first_visible_row)
			assert_equals ("6_row_274_is_first_fully_visible", grid.row (274), grid.first_fully_visible_row)
			assert_equals ("6_row_287_is_fully_visible", grid.row (287), grid.last_fully_visible_row)
			assert_equals ("6_row_288_is_partially_visible", grid.row (288), grid.last_visible_row)
			check selected_item_1: attached grid.item (3, 274) as al_item then
				l_item := al_item
			end
			assert ("6_item_3_274_selected", l_item.is_selected)
			assert_equals ("6_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				--| 7. After ctrl + page up
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_up))
			application.set_is_control_key_pressed (False)
			assert_equals ("7_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("7_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("7_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("7_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			check selected_item_1: attached grid.item (3, 1) as al_item then
				l_item := al_item
			end
			assert ("7_item_3_1_selected", l_item.is_selected)
			assert_equals ("7_vertical_scroll_bar_position_top", proportion_top_left, grid.vertical_scroll_bar.proportion)
			assert_equals ("7_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- Home/End
				-- 8. After end.
			assert_equals ("8_vertical_scroll_bar_position_left", proportion_top_left, grid.vertical_scroll_bar.proportion)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_end))
			assert_equals ("8_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("8_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("8_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("8_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			check selected_item_1: attached grid.item (10, 1) as al_item then
				l_item := al_item
			end
			assert ("8_item_10_1_selected", l_item.is_selected)
			assert_equals ("8_vertical_scroll_bar_position_top", proportion_top_left, grid.vertical_scroll_bar.proportion)
			assert_equals ("8_horizontal_scroll_bar_position_right", proportion_bottom_right, grid.horizontal_scroll_bar.proportion)
			l_virtual_x_position := grid.column (1).virtual_x_position
			assert ("8_first_column_not_shown", l_virtual_x_position < grid.virtual_x_position)
			l_virtual_x_position := grid.column (grid.column_count).virtual_x_position
			assert ("8_last_column_shown", l_virtual_x_position <= grid.virtual_x_position + grid.viewable_width)

				-- 9. After ctrl + page down
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			application.set_is_control_key_pressed (False)
			assert_equals ("9_row_287_is_first_visible", grid.row (287), grid.first_visible_row)
			assert_equals ("9_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("9_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("9_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			check selected_item_1: attached grid.item (10, 300) as al_item then
				l_item := al_item
			end
			assert ("9_item_10_300_selected", l_item.is_selected)
			assert_equals ("9_vertical_scroll_bar_position_bottom", proportion_bottom_right, grid.vertical_scroll_bar.proportion)
			assert_equals ("9_horizontal_scroll_bar_position_right", proportion_bottom_right, grid.horizontal_scroll_bar.proportion)

				-- 10. After home
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			assert_equals ("10_row_287_is_first_visible", grid.row (287), grid.first_visible_row)
			assert_equals ("10_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("10_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("10_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			check selected_item_1: attached grid.item (1, 300) as al_item then
				l_item := al_item
			end
			assert ("10_item_1_300_selected", l_item.is_selected)
			assert_equals ("10_vertical_scroll_bar_position_bottom", proportion_bottom_right, grid.vertical_scroll_bar.proportion)
			assert_equals ("10_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)
			assert ("10_first_column_shown", grid.column (1).virtual_x_position = grid.virtual_x_position)
			assert ("10_last_column_not_shown", grid.column (grid.column_count).virtual_x_position > grid.virtual_x_position + grid.viewable_width)

				-- 11. After ctrl + page up
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_up))
			application.set_is_control_key_pressed (False)
			assert_equals ("11_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("11_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("11_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("11_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			check selected_item_1: attached grid.item (1, 1) as al_item then
				l_item := al_item
			end
			assert ("11_item_1_1_selected", l_item.is_selected)
			assert_equals ("11_vertical_scroll_bar_position_top", proportion_top_left, grid.vertical_scroll_bar.proportion)
			assert_equals ("11_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 12. Select item at col 5, row 42
			check selected_item_1: attached grid.item (5, 42) as al_item then
				l_item := al_item
				al_item.ensure_visible
				al_item.enable_select
			end
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			assert_equals ("12_row_28_is_first_visible", grid.row (28), grid.first_visible_row)
			assert_equals ("12_row_29_is_first_fully_visible", grid.row (29), grid.first_fully_visible_row)
			assert_equals ("12_row_42_is_fully_visible", grid.row (42), grid.last_fully_visible_row)
			assert_equals ("12_row_43_is_partially_visible", grid.row (43), grid.last_visible_row)
			check selected_item_1: attached grid.item (1, 42) as al_item then
				l_item := al_item
			end
			assert ("12_item_1_42_selected", l_item.is_selected)
			assert_equals ("12_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 13. After ctrl + end
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_end))
			application.set_is_control_key_pressed (False)
			assert_equals ("13_row_286_is_first_visible", grid.row (286), grid.first_visible_row)
			assert_equals ("13_row_287_is_first_fully_visible", grid.row (287), grid.first_fully_visible_row)
			assert_equals ("13_row_300_is_fully_visible", grid.row (300), grid.last_fully_visible_row)
			assert_equals ("13_row_300_is_partially_visible", grid.row (300), grid.last_visible_row)
			check selected_item_1: attached grid.item (10, 300) as al_item then
				l_item := al_item
			end
			assert ("13_item_10_300_selected", l_item.is_selected)
			assert_equals ("13_horizontal_scroll_bar_position_right", proportion_bottom_right, grid.horizontal_scroll_bar.proportion)

				-- Select item at col 5 row 42 again
			check selected_item_1: attached grid.item (5, 42) as al_item then
				l_item := al_item
				al_item.ensure_visible
				al_item.enable_select
			end
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_end))
			check selected_item_1: attached grid.item (10, 42) as al_item then
				l_item := al_item
			end
			assert ("14_item_10_42_selected", l_item.is_selected)
				-- 14. After ctrl + home
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			application.set_is_control_key_pressed (False)
			assert_equals ("14_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("14_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("14_row_14_is_fully_visible", grid.row (14), grid.last_fully_visible_row)
			assert_equals ("14_row_15_is_partially_visible", grid.row (15), grid.last_visible_row)
			check selected_item_1: attached grid.item (1, 1) as al_item then
				l_item := al_item
			end
			assert ("14_item_1_1_selected", l_item.is_selected)
			assert_equals ("14_horizontal_scroll_bar_position_left", proportion_top_left, grid.horizontal_scroll_bar.proportion)

				-- 15. Hide last column and test navigation
			grid.column (grid.column_count).hide
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_end))
			check selected_item_1: attached grid.item (9, 1) as al_item then
				l_item := al_item
			end
			assert ("15_item_9_1_selected", l_item.is_selected)
			l_virtual_x_position := grid.column (1).virtual_x_position
			assert ("15_first_column_not_shown", l_virtual_x_position < grid.virtual_x_position)
			assert ("15_last_column_not_shown", not grid.column (grid.column_count).is_show_requested)
			l_virtual_x_position := grid.column (grid.column_count - 1).virtual_x_position
			assert ("15_next_to_last_column_shown", grid.virtual_x_position <= l_virtual_x_position and l_virtual_x_position <=  grid.virtual_x_position + grid.viewable_width)
			grid.column (grid.column_count).show

				-- 16. Hide first column and test navigation
			grid.column (1).hide
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			check selected_item_1: attached grid.item (2, 1) as al_item then
				l_item := al_item
			end
			assert ("16_item_2_1_selected", l_item.is_selected)
			assert ("16_first_column_not_shown", not grid.column (1).is_show_requested)
			l_virtual_x_position := grid.column (2).virtual_x_position
			assert ("16_second_column_shown", grid.virtual_x_position <= l_virtual_x_position and l_virtual_x_position <=  grid.virtual_x_position + grid.viewable_width)
			assert ("16_last_column_not_shown", grid.column (grid.column_count).virtual_x_position > grid.virtual_x_position + grid.viewable_width)
			grid.column (1).show

				-- 17. Select row 4, check that it's a subrow, hide it, perform calcs based on hidden row.
			l_subrow := grid.row (4)
			assert ("17_row_4_has_parent_row", attached l_subrow.parent_row)
			check attached l_subrow.parent_row as al_parent_row then
				al_parent_row.collapse
				assert ("17_row_4_hidden", not al_parent_row.is_expanded)
			end
			assert_equals ("1_299_visible_rows", 299, grid.visible_row_count)
			application.set_is_control_key_pressed (True)
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_home))
			application.set_is_control_key_pressed (False)
			check selected_item_1: attached grid.item (1, 1) as al_item then
				l_item := al_item
			end
			assert ("17_item_1_1_selected", l_item.is_selected)
			assert_equals ("17_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("17_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("17_row_15_is_fully_visible", grid.row (15), grid.last_fully_visible_row)
			assert_equals ("17_row_16_is_partially_visible", grid.row (16), grid.last_visible_row)

				-- 18. After page down.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			assert_equals ("18_row_1_is_first_visible", grid.row (1), grid.first_visible_row)
			assert_equals ("18_row_1_is_first_fully_visible", grid.row (1), grid.first_fully_visible_row)
			assert_equals ("18_row_15_is_fully_visible", grid.row (15), grid.last_fully_visible_row)
			assert_equals ("18_row_16_is_partially_visible", grid.row (16), grid.last_visible_row)
			check selected_item_1: attached grid.item (1, 15) as al_item then
				l_item := al_item
			end
			assert ("18_item_1_15_selected", l_item.is_selected)

				-- 19. After page down again.
			grid.handle_key_press (create {EV_KEY}.make_with_code (key_page_down))
			assert_equals ("19_row_14_is_first_visible", grid.row (14), grid.first_visible_row)
			assert_equals ("19_row_15_is_first_fully_visible", grid.row (15), grid.first_fully_visible_row)
			assert_equals ("19_row_28_is_fully_visible", grid.row (28), grid.last_fully_visible_row)
			assert_equals ("19_row_29_is_partially_visible", grid.row (29), grid.last_visible_row)
			check selected_item_1: attached grid.item (1, 28) as al_item then
				l_item := al_item
			end
			assert ("19_item_1_28_selected", l_item.is_selected)
		end

feature {NONE} -- Implementation

	item_agent: FUNCTION [ANY, TUPLE [INTEGER_32, INTEGER_32], EV_GRID_ITEM]
			-- Agent to load dynamic content.

	item (a_column_index, a_row_index: INTEGER): EV_GRID_EDITABLE_ITEM
			-- An item with text set to `a_column_index' plus `a_row_index'.
		do
			create Result
			Result.set_text (a_column_index.out + ", " + a_row_index.out)
		end

	add_items (a_columns, a_rows: INTEGER)
			-- Add parent items to `grid'.
		local
			l_grid_item: EV_GRID_EDITABLE_ITEM
			l_column_index, l_row_index: INTEGER
		do
			from
				l_row_index := 1
			until
				l_row_index > a_rows
			loop
				from
					l_column_index := 1
				until
					l_column_index > a_columns
				loop
					l_grid_item := item (l_column_index, l_row_index)
					grid.set_item (l_column_index, l_row_index, l_grid_item)
					l_column_index := l_column_index + 1
				end
				l_row_index := l_row_index + 1
			end
		end

	add_subrows
			-- Make every even indexed row in `grid' a subrow.
		require
			grid_has_rows: grid.row_count > 0 and grid.column_count > 0
		local
			l_row_index: INTEGER
			l_row, l_subrow: EV_GRID_ROW
		do
			from
				l_row_index := 2
			until
				l_row_index > grid.row_count
			loop
				if l_row_index \\ 2 = 0 then
					l_row := grid.row (l_row_index - 1)
					l_subrow := grid.row (l_row_index)
					l_row.add_subrow (l_subrow)
				end
				l_row_index := l_row_index + 1
			end
		end

	expand_subrows
			-- Expand all subrows.
		require
			grid_has_rows: grid.row_count > 0 and grid.column_count > 0
			grid_is_treed: grid.is_tree_enabled
		local
			l_row_index: INTEGER
			l_row: EV_GRID_ROW
		do
			from
				l_row_index := 1
			until
				l_row_index > grid.row_count
			loop
				l_row := grid.row (l_row_index)
				if l_row.is_expandable then
					l_row.expand
				end
				l_row_index := l_row_index + 1
			end
		end

	set_column_titles
			-- Set column titles to "Column " plus column number.
		local
			l_column_index: INTEGER
		do
			from
				l_column_index := 1
			until
				l_column_index > grid.column_count
			loop
				grid.column (l_column_index).set_title ("Column " + l_column_index.out)
				l_column_index := l_column_index + 1
			end
		end

	grid: JV_GRID

	application: TEST_APPLICATION
		once
			Create Result
		end

	on_prepare
			-- <Precursor>
		local
			l_application: TEST_APPLICATION
		do
			l_application := application
			create grid
			item_agent := agent item
		end

	proportion_top_left: REAL_32 = 0.0
	proportion_bottom_right: REAL_32 = 1.0

end
