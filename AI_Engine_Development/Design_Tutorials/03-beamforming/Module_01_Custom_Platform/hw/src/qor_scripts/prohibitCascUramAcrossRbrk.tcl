# © Copyright 2022 Xilinx, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

catch {unset ys}
foreach cr [get_clock_regions {X*Y1 X*Y2 X*Y3}] {
  set uram [get_sites -quiet -filter NAME=~URAM288_X*Y* -of $cr]
  if {$uram == {}} { continue }
  lappend ys [lindex [lsort -integer -increasing [regsub -all {URAM288_X\d+Y(\d+)} $uram {\1}]] end]
}
foreach y $ys {
  set_property PROHIBIT TRUE [get_sites URAM288_X*Y$y]
}
