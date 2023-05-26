{******************************************************************************}
{                                                                              }
{       ShellControls Packages and Utils                                       }
{                                                                              }
{       Copyright (c) 2023 (Ethea S.r.l.)                                      }
{       Author: Carlo Barazzetta                                               }
{                                                                              }
{       https://github.com/EtheaDev/ShellControlsPackages                      }
{                                                                              }
{******************************************************************************}
{                                                                              }
{  Licensed under the Apache License, Version 2.0 (the "License");             }
{  you may not use this file except in compliance with the License.            }
{  You may obtain a copy of the License at                                     }
{                                                                              }
{      http://www.apache.org/licenses/LICENSE-2.0                              }
{                                                                              }
{  Unless required by applicable law or agreed to in writing, software         }
{  distributed under the License is distributed on an "AS IS" BASIS,           }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    }
{  See the License for the specific language governing permissions and         }
{  limitations under the License.                                              }
{                                                                              }
{******************************************************************************}
unit Vcl.Shell.Utils;

interface

uses
  System.SysUtils
  , System.IOUtils
  , Winapi.Windows
  , Winapi.ShlObj
  ;

const
  Icon_default_file=1;
  Icon_default_document=2;
  Icon_default_exe_file=3;
  Icon_closed_folder=4;
  Icon_opened_folder=5;
  Icon_5_1_4_disk=6;
  Icon_3_1_2_disk=7;
  Icon_other_removeable_media=8;
  Icon_hard_drive=9;
  Icon_network_drive=10;
  Icon_disconnected_network_drive=11;
  Icon_cd_rom_drive=12;
  Icon_ram_drive=13;
  Icon_network_globe=14;
  Icon_network_mouse=15;
  Icon_my_computer=16;
  Icon_printer=17;
  Icon_network_computer=18;
  Icon_entire_network=19;
  Icon_program_group=20;
  Icon_my_recent_documents=21;
  Icon_control_panel=22;
  Icon_find=23;
  Icon_help=24;
  Icon_run=25;
  Icon_good_night=26;
  Icon_undock=27;
  Icon_shutdown=28;
  Icon_shared=29;
  Icon_shortcut=30;
  Icon_scheduled_task_overlay=31;
  Icon_recycle_bin_empty=32;
  Icon_recycle_bin_full=33;
  Icon_telephony=34;
  Icon_desktop=35;
  Icon_old_settings=36;
  Icon_old_printer=38;
  Icon_fonts=39;
  Icon_taskbar_properties=40;
  Icon_music_cd=41;
  Icon_tree=42;
  Icon_old_computer_folder=43;
  Icon_favorites_star=44;
  Icon_log_off=45;
  Icon_find_in_folder=46;
  Icon_windows_update=47;
  Icon_lock=48;
  Icon_computer_app=49;
  Icon_old_mistery_drive=54;
  Icon_file_stack=133;
  Icon_find_files=134;
  Icon_find_computer_glyph=135;
  Icon_printer_folder=138;
  Icon_add_printer=139;
  Icon_network_printer=140;
  Icon_print_to_file=141;
  Icon_old_recycle_bin_full=142;
  Icon_old_recycle_bin_full_of_folders=143;
  Icon_old_recycle_bin_full_of_folders_and_files=144;
  Icon_can_t_copy_overwrite_file=145;
  Icon_move_to_folder=146;
  Icon_old_rename=147;
  Icon_old_settings_copy=148;
  Icon_ini_file=151;
  Icon_txt_file=152;
  Icon_bat_file=153;
  Icon_dll_file=154;
  Icon_font_file=155;
  Icon_true_type_font_file=156;
  Icon_other_font_file=157;
  Icon_old_delete=161;
  Icon_copy_to_disk=165;
  Icon_error_checking=166;
  Icon_defragment=167;
  Icon_printer_ok=168;
  Icon_network_printer_ok=169;
  Icon_printer_ok_file=170;
  Icon_file_tree_structure=171;
  Icon_network_folder=172;
  Icon_favorites_folder=173;
  Icon_old_weird_folder=174;
  Icon_network_connect_to_globe=175;
  Icon_add_network_folder=176;
  Icon_old_htt_file=177;
  Icon_add_network=178;
  Icon_old_network_terminal_thing=179;
  Icon_screen_full=180;
  Icon_screen_empty=181;
  Icon_folder_options_window_image_with_webview=182;
  Icon_folder_options_window_image_without_webview=183;
  Icon_folder_options_open_in_new_window=185;
  Icon_folder_options_click_files_link_style=186;
  Icon_folder_options_click_files_normal_style=187;
  Icon_old_bin_empty=191;
  Icon_old_bin_full=192;
  Icon_web_browser=193;
  Icon_old_login_keys=194;
  Icon_fax=196;
  Icon_fax_ok=197;
  Icon_network_fax_ok=198;
  Icon_network_fax=199;
  Icon_stop=200;
  Icon_folder_settings=210;
  Icon_old_key_users=220;
  Icon_shutdown_blue_circle=221;
  Icon_dvd_disk=222;
  Icon_some_files=223;
  Icon_video_files=224;
  Icon_music_files=225;
  Icon_image_files=226;
  Icon_various_music_video_files=227;
  Icon_old_music_disk=228;
  Icon_hub=229;
  Icon_zip_drive=230;
  Icon_down_overlay=231;
  Icon_down_overlay_again=232;
  Icon_no_disk_drive_disabled=234;
  Icon_my_documents=235;
  Icon_my_pictures=236;
  Icon_my_music=237;
  Icon_my_videos=238;
  Icon_msn=239;
  Icon_delete_webview=240;
  Icon_copy_webview=241;
  Icon_rename_webview=242;
  Icon_files_webview=243;
  Icon_globe_w_arrow=244;
  Icon_printer_printing=245;
  Icon_green_arrow_webview=246;
  Icon_music_webview=247;
  Icon_camera=248;
  Icon_board=249;
  Icon_display_properties=250;
  Icon_network_images=251;
  Icon_print_images=252;
  Icon_ok_file_webview=253;
  Icon_bin_empty=254;
  Icon_green_cool_arrow_webview=255;
  Icon_move=256;
  Icon_network_connection=257;
  Icon_network_drive_red_thing=258;
  Icon_network_home=259;
  Icon_write_cd_webview=260;
  Icon_cd_thing_webview=261;
  Icon_destroy_cd_webview=262;
  Icon_move_to_folder_webview=264;
  Icon_send_mail_webview=265;
  Icon_move_to_cd_webview=266;
  Icon_shared_folder=267;
  Icon_accessibilty_options=268;
  Icon_users_xp=269;
  Icon_screen_palette=270;
  Icon_add_or_remove_programs=271;
  Icon_mouse_printer=272;
  Icon_network_computers=273;
  Icon_gear_settings=274;
  Icon_drive_use_piechart=275;
  Icon_network_calender_syncronise=276;
  Icon_music_cpanel=277;
  Icon_app_settings=278;
  Icon_old_find_files=281;
  Icon_talking_computer=282;
  Icon_screen_keyboard=283;
  Icon_black_thingy=284;
  Icon_help_file=289;
  Icon_go_arrow_ie=290;
  Icon_dvd_drive=291;
  Icon_unknown_cd=293;
  Icon_cd_rom=294;
  Icon_cd_r=295;
  Icon_cd_rw=296;
  Icon_dvd_ram=297;
  Icon_dvd_r=298;
  Icon_walkman=299;
  Icon_cassete_drive=300;
  Icon_smaller_cassete_drive=301;
  Icon_cd=302;
  Icon_red_thing=303;
  Icon_dvd_rom=304;
  Icon_cards=306;
  Icon_cards_2=307;
  Icon_cards_3=308;
  Icon_cellphone=310;
  Icon_network_printer_globe=311;
  Icon_jazz_drive=312;
  Icon_pda=314;
  Icon_scanner=315;
  Icon_scanner_and_camera=316;
  Icon_video_camera=317;
  Icon_new_folder_red_thing=319;
  Icon_move_to_disk_webview=320;
  Icon_control_panel_third_time=321;
  Icon_start_menu_favorites_smaller_icon=322;
  Icon_start_menu_find_smaller_icon=323;
  Icon_start_menu_help_smaller_icon=324;
  Icon_start_menu_logoff_smaller_icon=325;
  Icon_start_menu_program_group_smaller_icon=326;
  Icon_start_menu_recent_documents_smaller_icon=327;
  Icon_start_menu_run_smaller_icon=328;
  Icon_start_menu_shutdown_smaller_icon=329;
  Icon_start_menu_control_panelsmaller_icon=330;
  Icon_start_menu_logoff_or_something_smaller_icon=331;
  Icon_old_lookup_phonebook=337;
  Icon_stop_again=338;
  Icon_internet_explorer=512;

function GetSpecialFolderPath(CSIDLFolder: Integer): string;

function GetIconsFromShell32(const AIconIndex: integer;
  var ALargeIcon, ASmallIcon: HICON): boolean;

function GetAssociatedIcon(PIDL: PItemIDList; Large, Open: Boolean): HICON;

function GetAssociatedIcons(const AFileExt: TFilename; var ALargeIcon, ASmallIcon: HICON): boolean;

function GetFileIcons(const AFileName: TFilename; var ALargeIcon, ASmallIcon: HICON): boolean;

procedure GetFileSummary(const AFileName: TFileName;
  out AFileType: string; out ACreationDateTime, AChangedDateTime: TDateTime);

implementation

uses
  Winapi.ShellAPI
  ;

function GetSpecialFolderPath(CSIDLFolder: Integer): string;
var
  LFilePath: array [0..MAX_PATH] of WideChar;
begin
  SHGetFolderPath(0, CSIDLFolder, 0, 0, LFilePath);
  Result := string(LFilePath);
end;

function GetIconsFromShell32(const AIconIndex: Integer;
  var ALargeIcon, ASmallIcon: HICON): boolean;
var
  LShell32FileName: TFileName;
  LSystemPath: string;
begin
  // load icons from SHELL32.DLL
  LSystemPath := GetSpecialFolderPath(CSIDL_SYSTEM);
  LShell32FileName := LSystemPath+PathDelim+'shell32.dll';
  if fileExists(LShell32FileName) then
  begin
    // Attempt to get the icon.
    ExtractIconEx(PChar(LShell32FileName), AIconIndex, ALargeIcon, ASmallIcon, 1);
    Result := True;
  end
  else
    Result := False;
end;

function GetAssociatedIcon(PIDL: PItemIDList; Large, Open: Boolean): HICON;
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
begin
  Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_ICON;
  if Open then Flags := Flags or SHGFI_OPENICON;
  if Large then Flags := Flags or SHGFI_LARGEICON
  else Flags := Flags or SHGFI_SMALLICON;
  SHGetFileInfo(PChar(PIDL),
                0,
                FileInfo,
                SizeOf(FileInfo),
                Flags);
  Result := FileInfo.hIcon;
end;

function GetAssociatedIcons(const AFileExt: TFilename; var ALargeIcon, ASmallIcon: HICON): boolean;
var
  LFileExt: string;
  FileInfo: TSHFileInfo;
begin
  LFileExt := ExtractFileExt(AFileExt);
  //Get the Small Icon Form File Extensions
  SHGetFileInfo(PChar(LFileExt),
    FILE_ATTRIBUTE_NORMAL,
    FileInfo,SizeOf(FileInfo),
    SHGFI_ICON or SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  ASmallIcon := FileInfo.hIcon;

  //Get the Large Icon Form File Extensions
  SHGetFileInfo(PChar(LFileExt),
    FILE_ATTRIBUTE_NORMAL,
    FileInfo,SizeOf(FileInfo),
    SHGFI_ICON or SHGFI_LARGEICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  ALargeIcon := FileInfo.hIcon;

  Result := (FileInfo.IIcon <> 0);
end;

function GetFileIcons(const AFileName: TFilename; var ALargeIcon, ASmallIcon: HICON): boolean;
var
  FileInfo: TSHFileInfo;
begin
  //Get the Small Icon Form File Extensions
  SHGetFileInfo(PChar(AFileName),
    FILE_ATTRIBUTE_NORMAL,
    FileInfo,SizeOf(FileInfo),
    SHGFI_ICON or SHGFI_SMALLICON);
  ASmallIcon := FileInfo.hIcon;

  //Get the Large Icon Form File Extensions
  SHGetFileInfo(PChar(AFileName),
    FILE_ATTRIBUTE_NORMAL,
    FileInfo,SizeOf(FileInfo),
    SHGFI_ICON or SHGFI_LARGEICON);
  ALargeIcon := FileInfo.hIcon;

  Result := (FileInfo.IIcon <> 0);
end;

procedure GetFileSummary(const AFileName: TFileName;
  out AFileType: string; out ACreationDateTime, AChangedDateTime: TDateTime);
var
  MyS: TWin32FindData;
  MyTime: TFileTime;
  MySysTime: TSystemTime;
begin
    FindFirstFile(PChar(AFileName), MyS);

    MyTime := MyS.ftCreationTime;
    FileTimeToSystemTime(MyTime, MySysTime);
    ACreationDateTime := EncodeDate(MySysTime.wYear, MySysTime.wMonth, MySysTime.wDay)+
      EncodeTime(MySysTime.wHour, MySysTime.wMinute, MySysTime.wSecond, MySysTime.wMilliseconds);

    MyTime:=MyS.ftLastAccessTime;
    FileTimeToSystemTime(MyTime, MySysTime);
    AChangedDateTime := EncodeDate(MySysTime.wYear, MySysTime.wMonth, MySysTime.wDay)+
      EncodeTime(MySysTime.wHour, MySysTime.wMinute, MySysTime.wSecond, MySysTime.wMilliseconds);
  end;
end.
