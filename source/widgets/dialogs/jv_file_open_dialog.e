note
	description: "Summary description for {JV_FILE_OPEN_DIALOG}."
	date: "$Date: 2015-01-06 20:22:09 -0500 (Tue, 06 Jan 2015) $"
	revision: "$Revision: 10511 $"

class
	JV_FILE_OPEN_DIALOG

inherit
	EV_FILE_OPEN_DIALOG
		redefine
			initialize
		end

create
	default_create,
	make_with_title

feature {NONE} -- Initialization

	initialize
			-- <Precursor>
		do
			Precursor
			open_actions.put_front (agent file_existence_validation_on_open_request)
		end

feature {NONE} -- Implementation

	file_existence_validation_on_open_request
			-- Checks for existance of `file_name', warning user if file is not found.
		local
			l_file: PLAIN_TEXT_FILE
			l_warning_dialog: JV_WARNING_DIALOG
		do
			create l_file.make_with_path (full_file_path)
			if not l_file.exists then
				create l_warning_dialog.make_with_text ("File not found.%NCheck the file name and try again.")
				l_warning_dialog.show
			end
		end

end
