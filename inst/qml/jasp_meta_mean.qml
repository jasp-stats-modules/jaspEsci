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

	function dlab() {
    if (from_raw.checked) {
      means.label = qsTr("Means")
    } else {
      means.label = qsTr("Cohen's <i>d</i>, unbiased")
    }
    means = null

  }


  RadioButtonGroup {
    columns: 2
    name: "switch"
    id: switch_source

    RadioButton {
      value: "from_raw";
      label: qsTr("Analyze original units");
      checked: true;
      id: from_raw
      onClicked: {
         dlab()
      }
    }

    RadioButton {
      value: "from_d";
      label: qsTr("Analyze Cohen's <i>d</i>");
      id: from_d
      onClicked: {
         dlab()
      }
    }
  }  // from d group


      	VariablesForm {
      	  height: 40
      		AvailableVariablesList {
      		  name: "allVariablesList"
      		  id: allVariablesList
      		}
      		AssignedVariablesList {
      		  name: "means";
      		  id: means
      		  label: qsTr("Means");
      		  allowedColumns: ["scale"];
      		  singleVariable: true
      		}
      		AssignedVariablesList {
      		  name: "sds";
      		  id: sds;
      		  title: qsTr("Standard deviations");
      		  allowedColumns: ["scale"];
      		  singleVariable: true
      		  enabled: from_raw.checked
      		  visible: from_raw.checked
      		}
      		AssignedVariablesList {
      		  name: "ns";
      		  id: ns
      		  title: qsTr("Sample sizes");
      		  allowedColumns: ["scale"];
      		  singleVariable: true
      		}
      		AssignedVariablesList {
      		  name: "labels";
      		  id: mylabels
      		  title: qsTr("Study labels (optional");
      		  allowedColumns: ["nominal"];
      		  singleVariable: true
      		}
      		AssignedVariablesList {
      		  name: "moderator";
      		  id: moderator;
      		  title: qsTr("Moderator (optional");
      		  allowedColumns: ["nominal"];
      		  singleVariable: true
      		}
      	} // variable selection group


	Group {
		title: qsTr("<b>Analysis options</b>")
		columns: 1
		Layout.rowSpan: 1

		Esci.ConfLevel {
		    name: "conf_level"
		    id: conf_level
		}

    TextField {
        name: "effect_label"
        label: qsTr("Effect label")
        placeholderText: qsTr("My effect")
    }

    TextField {
        name: "reference_mean"
        label: qsTr("Compare to reference value")
        afterLabel: "(blank for none)"
        enabled: from_raw.checked
    }

		DropDown {
        name: "reported_effect_size"
        label: qsTr("Effect size of interest")
        startValue: 'mean_difference'
        enabled: from_raw.checked
        values:
          [
            { label: qsTr("Original units"), value: "mean_difference"},
            { label: qsTr("Standardized mean difference"), value: "smd_unbiased"}
          ]
        id: effect_size
    }

    DropDown {
        name: "random_effects"
        label: qsTr("Model")
        startValue: 'random_effects'
        values:
          [
            { label: qsTr("Random effects (RE)"), value: "random_effects"},
            { label: qsTr("Fixed effect (FE)"), value: "fixed_effects"},
            { label: qsTr("Compare fixed and random effects"), value: "compare"}
          ]
        id: random_effects
    }
	}  // analysis options


	Group {
	  title: qsTr("<b>Results options</b>")
		columns: 1
		Layout.columnSpan: 2

	  CheckBox {
	    name: "show_details";
	    id: show_details
	    label: qsTr("Extra details")
	  }

	  CheckBox {
	    name: "include_PIs";
	    label: qsTr("Prediction intervals")
	    enabled: random_effects.currentValue == "random_effects"
	  }

	} // results options


  Esci.MetaFigureOptions {



  }

    Esci.MetaAesthetics {

    }


}  // form
