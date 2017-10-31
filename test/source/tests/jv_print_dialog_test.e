note
	description: "Test for {JV_PRINT_DIALOG}."
	date: "$Date: 2015-06-17 21:26:39 -0400 (Wed, 17 Jun 2015) $"
	revision: "$Revision: 11498 $"
	testing: "type/manual"

class
	JV_PRINT_DIALOG_TEST

inherit
	EQA_TEST_SET
		rename
			assert as assert_old
		redefine
			on_prepare
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end

	TEST_SET_BRIDGE
		undefine
			default_create
		end

	EV_KEY_CONSTANTS
		undefine
			default_create
		end

feature -- Tests

	test_jv_print_dialog
		note
			testing:  "run/checkin/regular", "execution/isolated"
		local
			l_print_dialog: JV_PRINT_DIALOG
			l_window: EV_WINDOW
			l_printer: STRING_32
		do
			create l_window
			l_window.show
				--| Used the name of a PDF on my local machine for this example. Provide the appropriate PDF name as the argument when creation the dialog.
			create l_print_dialog.make_with_pdf_file_name_and_printer_executable_path ("abc.pdf", "C:\Program Files (x86)\Total PDF Printer X\PDFPrinterX.exe")
			assert ("printers_count_greater_than_0", l_print_dialog.printers.count > 0)
			l_printer := l_print_dialog.printers.i_th (l_print_dialog.printers.count)
			l_print_dialog.set_selected_printer_name (l_printer)
				--| l_print_dialog.printer_name won't actually be set until the dialog is shown.
--			assert_equals ("printer_selected", l_printer, l_print_dialog.printer_name)
				--| Uncomment the show call and manually test to see that the printer was selected.
--			l_print_dialog.show_modal_to_window (l_window)
		end

feature {NONE} -- Implementation

	print_dialog: JV_PRINT_DIALOG

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
			create print_dialog
		end

end
