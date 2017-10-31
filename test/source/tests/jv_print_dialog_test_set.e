note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2015-08-05 11:35:16 -0400 (Wed, 05 Aug 2015) $"
	revision: "$Revision: 11916 $"
	testing: "type/manual"

class
	JV_PRINT_DIALOG_TEST_SET

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

feature -- Test routines

	test_print_browser
			-- New test routine
		note
			testing:
				"covers/{JV_PRINT_DIALOG}.make_with_pdf_file_name",
				"covers/{JV_PRINT_DIALOG}.default_create",
				"covers/{JV_PRINT_DIALOG}.print_actions",
				"covers/{JV_PRINT_DIALOG}.print_pdf"
		local
			l_print_dialog: JV_PRINT_DIALOG
		do
			create l_print_dialog.make_with_pdf_file_name_and_printer_executable_path ("blah.pdf", "C:\Program Files (x86)\Total PDF Printer X\PDFPrinterX.exe")
		end

feature {NONE} -- Implementation

	on_prepare
			-- <Precursor>
		do
			Precursor
		end

end


