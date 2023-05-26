{***************************************************************************}
{                                                                           }
{       Delphi Visual Component Library                                     }
{                                                                           }
{  Copyright (c) 1995-2010 Embarcadero Technologies, Inc.                   }
{                                                                           }
{  You may only use this software if you are an authorized licensee         }
{  of Delphi, C++Builder or RAD Studio (Embarcadero Products).              }
{  This software is considered a Redistributable as defined under           }
{  the software license agreement that comes with the Embarcadero Products  }
{  and is subject to that software license agreement.                       }
{                                                                           }
{***************************************************************************}
unit ShellReg;

interface

procedure Register;

implementation

uses Classes, TypInfo, Controls, DesignIntf, ShellCtrls, ShellConsts, RootEdit;

procedure Register;
begin
  GroupDescendentsWith(TShellChangeNotifier, Controls.TControl);
  RegisterComponents(SPalletePage, [TShellTreeView, TShellComboBox, TShellListView,
    TShellChangeNotifier]);
  RegisterPropertyEditor(TypeInfo(TRoot), TShellTreeView, SPropertyName, TRootProperty);
  RegisterPropertyEditor(TypeInfo(TRoot), TShellComboBox, SPropertyName, TRootProperty);
  RegisterPropertyEditor(TypeInfo(TRoot), TShellListView, SPropertyName, TRootProperty);
  RegisterPropertyEditor(TypeInfo(TRoot), TShellChangeNotifier, SPropertyName, TRootProperty);
  RegisterComponentEditor(TShellTreeView, TRootEditor);
  RegisterComponentEditor(TShellListView, TRootEditor);
  RegisterComponentEditor(TShellComboBox, TRootEditor);
  RegisterComponentEditor(TShellChangeNotifier, TRootEditor);
end;

end.
