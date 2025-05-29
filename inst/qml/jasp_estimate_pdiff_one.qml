//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//

import QtQuick
import QtQuick.Layouts
import JASP
import JASP.Controls
import "./esci" as Esci

Form
{
	id: form
	property int framework:	Common.Type.Framework.Classical

	function alpha_adjust() {
	  myHeOptions.currentConfLevel = conf_level.value
  }

  function not_case_label_adjust() {
    not_case_label.text = "Not " + case_label.text
  }



  RadioButtonGroup {
    columns: 2
    name: "switch"
    id: switch_source

    RadioButton {
      value: "from_raw";
      label: qsTr("Analyze full data");
      checked: true;
      id: from_raw
    }

    RadioButton {
      value: "from_summary";
      label: qsTr("Analyze summary data");
      id: from_summary
    }
  }



  Section {
    enabled: from_raw.checked
    visible: from_raw.checked
    expanded: from_raw.checked

  	VariablesForm
  	{
  		preferredHeight: jaspTheme.smallDefaultVariablesFormHeight
  		AvailableVariablesList { name: "allVariablesList" }
  		AssignedVariablesList { name: "outcome_variable"; title: qsTr("Outcome variable"); allowedColumns: ["nominal", "ordinal"] }
  	}

  }


  Section {
    enabled: from_summary.checked
    visible: from_summary.checked
    expanded: from_summary.checked

    Group {



      GridLayout {
      id: sgrid
      columns: 2
      rowSpacing: 1
      columnSpacing: 1

        Item {}

        TextField
        {
          name: "outcome_variable_name"
          placeholderText: qsTr("Outcome variable")
        }


        TextField
        {
          name: "case_label"
          id: case_label
          label: ""
          defaultValue: "Affected"
          onEditingFinished : {
            summary_dirty.checked = true
          }
        }

        IntegerField
        {
          name: "cases"
          label: ""
          defaultValue: 20
          min: 0
          fieldWidth: jaspTheme.textFieldWidth
          onEditingFinished : {
            summary_dirty.checked = true
          }
        }

        TextField
        {
          name: "not_case_label"
          id: not_case_label
          enabled: false
          label: ""
          value: qsTr("Not ") + case_label.value
        }

        IntegerField
        {
          name: "not_cases"
          label: ""
          defaultValue: 80
          min: 0
          fieldWidth: jaspTheme.textFieldWidth
          onEditingFinished : {
            summary_dirty.checked = true
          }
        }
      }  // 2 column grid

            CheckBox
	    {
	      name: "summary_dirty";
	      id: summary_dirty
	      visible: false
	    }
    }  // end of group for summary

  }

	Group
	{
		title: qsTr("<b>Analysis options</b>")
		Layout.columnSpan: 2
		Esci.ConfLevel
		  {
		    name: "conf_level"
		    id: conf_level
		    onFocusChanged: {
         alpha_adjust()
        }
		  }

		CheckBox
	  {
	    name: "count_NA";
	    label: qsTr("Missing cases are counted")
	    enabled: from_raw.checked
	    visible: from_raw.checked
	   }
	}

	Group
	{
	  title: qsTr("<b>Results options</b>")
	  CheckBox
	  {
	    name: "show_details";
	    label: qsTr("Extra details")
	   }
	  CheckBox
	  {
	    name: "plot_possible";
	    label: qsTr("Lines at proportion intervals");
	   }
	}


  Esci.FigureOptions {
    simple_labels_enabled: false
    simple_labels_visible: false
    difference_axis_grid_visible: false
    data_grid_visible: false
    distributions_grid_visible: false
    ymin_placeholderText: "0"
    ymax_placeholderText: "1"

        Section
  {
    title: qsTr("Aesthetics")

    Esci.AestheticsSummary {

    }



    Group
    {
    title: "<b>CI</b>"
    columns: 2
    Layout.columnSpan: 2

      Esci.LineTypeSelect
      {
        label: qsTr("Style")
        name: "linetype_summary"
        id: linetype_summary
      }

    }


  }

  }



  Esci.HeOptions {
    id: myHeOptions
    null_value_min: 0
    null_value_max: 1
    null_value_negativeValues: false
    null_boundary_max: 1
  }


}
