; Night Kernel
; Copyright 2015 - 2020 by mercury0x0d
; PIC defines.inc is a part of the Night Kernel

; The Night Kernel is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
; License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
; version.

; The Night Kernel is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

; You should have received a copy of the GNU General Public License along with the Night Kernel. If not, see
; <http://www.gnu.org/licenses/>.

; See the included file <GPL License.txt> for the complete text of the GPL License by which this program is covered.





; variable definitions
%define kPIC1CmdPort							word 0x0020
%define kPIC1DataPort							word 0x0021
%define kPIC2CmdPort							word 0x00A0
%define kPIC2DataPort							word 0x00A1





; declare functions as global
global PICInit
global PICIntCompleteMaster
global PICIntCompleteSlave
global PICIRQDisable
global PICIRQDisableAll
global PICIRQEnable
global PICIRQEnableAll
