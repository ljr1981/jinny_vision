note
	description: "Test for {JV_LINE_GRAHP}"
	date: "$Date: 2014-11-24 12:55:10 -0500 (Mon, 24 Nov 2014) $"
	revision: "$Revision: 10305 $"
	testing: "type/manual"

class
	JV_LINE_GRAPH_TEST

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

	test_jv_line_graph
		note
			testing:  "run/checkin/regular", "execution/isolated"
		do
			--| TODO:
		end

feature {NONE} -- Implementation

	line_graph: JV_LINE_GRAPH

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
			create line_graph
		end

end
