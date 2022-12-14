#!/bin/bash --noprofile

# Based on https://github.com/QEF/benchmarks
# and https://github.com/QEF/q-e/releases/tag/qe-7.0

################################################################################
##                    Copyright (C) 2004 Carlo Sbraccia.                      ##
##                 This file is distributed under the terms                   ##
##                 of the GNU General Public License.                         ##
##                 See http://www.gnu.org/copyleft/gpl.txt .                  ##
##                                                                            ##
##    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,         ##
##    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF      ##
##    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                   ##
##    NONINFRINGEMENT.  IN NO EVENT SHALL CARLO SBRACCIA BE LIABLE FOR ANY    ##
##    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,    ##
##    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE       ##
##    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                  ##
################################################################################
#
# ... Usage: pwscf_bench.sh [ number of tests ]
# ... number of tests can be 1 to a maximum of 4 different tests
# ... if nothing is specified, or nothing valid, 4 is assumed
#
# ... architecture to be tested
#
ARCH=Gold6354
#
# ... path to the pw.x executable
#
EXE="/opt/apps/qe-gnu/bin/pw.x"
#EXE="$HOME/espressostable/espresso-4.0.4/bin/pw.x"
#
# ... path to the scratch directory
#
SCRATCH_DIR="$HOME/scratch"
#
# ... variables for parallel execution
#
#PREFIX="mpirun -np 2 "
POSTFIX=""
#
################################################################################
################################################################################
######             DO NOT MODIFY THE SCRIPT UNDER THESE LINES             ######
################################################################################
################################################################################
#
if test "$#" != 0; then
   num_of_tests=$1
else
   num_of_tests=4
fi
echo $num_of_tests
#
if [[ ${num_of_tests} -gt 4 ||  ${num_of_tests} -lt 1 ]]; then
   #
   printf "\n num_of_tests = ${num_of_tests}  (must be > 0 and < 5):"
   printf "  num_of_tests set to 4 \n\n"
   #
   num_of_tests=4
   #
fi
#
#  ... reference results
#
REFERENCE="opteron-ictp-2cpu"
#
ref_t[1]=205.90
ref_t[2]=693.41
ref_t[3]=2854.13
ref_t[4]=4977.66
#
ref_e[1]=-253.633943480
ref_e[2]=-3541.13059179
ref_e[3]=-5057.82430045
ref_e[4]=-2588.56989200
#
PSEUDO_DIR="$PWD/pseudopotentials.d"
#
printf "\n bechmarking PWscf on $ARCH :  ${num_of_tests} test to be done\n"
printf "\n reference system is $REFERENCE \n\n"
#
# ... first all the input files are written
#
cat > test_1.in << EOF
&CONTROL
  outdir      = "$SCRATCH_DIR",
  pseudo_dir  = "$PSEUDO_DIR",
/
&SYSTEM
  ibrav     = 8,
  celldm(1) = 22.0D0,
  celldm(2) = 0.85D0,
  celldm(3) = 1.20D0,
  nat       = 28,
  ntyp      = 4,
  ecutwfc   = 27.D0,
  ecutrho   = 200.D0,
/
&ELECTRONS
  diago_david_ndim = 3,
  conv_thr         = 1.D-8,
  mixing_beta      = 0.3,
  mixing_ndim      = 4,
  !tqr=.true.
/
ATOMIC_SPECIES
C   1.0   C.pbe-van_bm.UPF
O   1.0   O.pbe-rrkjus.UPF
N   1.0   NUSPBE.RRKJ3
H   1.0   H.US_PBE.RRKJ3.UPF
ATOMIC_POSITIONS
C   0.746118205    0.427658374    0.882167170
C   0.507385126    0.421836057    0.626632637
C   0.751323124    0.193445675    0.706230155
C   0.406787629    0.469699131    0.561654173
C   0.339426820    0.419133183    0.453807346
C   0.233584191    0.486327663    0.406775392
C   0.164060914    0.443217019    0.304080773
C   0.199472930    0.330340334    0.244708014
C   0.660280640    0.300498547    0.692884891
C   0.304289372    0.262033359    0.288648844
C   0.373178827    0.305466259    0.391637662
C   0.565021503    0.488255271    0.736913909
O   0.127400264    0.290497083    0.143139985
O   0.540563218    0.590624908    0.787668820
N   0.572222971    0.307549793    0.605723035
N   0.662173963    0.404293300    0.774886397
H   0.845434030    0.429592482    0.852540798
H   0.720577854    0.520026877    0.921031012
H   0.734103305    0.355647938    0.955804691
H   0.732102694    0.123268702    0.633004063
H   0.849463194    0.226166605    0.696924416
H   0.742731509    0.148052753    0.799228708
H   0.372329410    0.559880633    0.597940034
H   0.206009662    0.574229109    0.452596804
H   0.082669116    0.495213117    0.269009494
H   0.331658888    0.174436897    0.241810620
H   0.453978591    0.252472551    0.425889140
H   0.162285447    0.212362157    0.110027340
K_POINTS gamma
EOF
#
cat > test_2.in << EOF
&CONTROL
  outdir      = "$SCRATCH_DIR",
  pseudo_dir  = "$PSEUDO_DIR",
/
&SYSTEM
  ibrav       = 1,
  celldm(1)   = 15.1230D0,
  nat         = 64,
  ntyp        = 1,
  ecutwfc     = 17.4600D0,
  ecutrho     = 117.5200D0,
  nbnd        = 384,
  occupations = "smearing",
  smearing    = "m-p",
  degauss     = 0.0367D0,
/
&ELECTRONS
  diago_david_ndim = 3,
  conv_thr         = 1.0D-8,
  mixing_mode      = "local-TF",
  mixing_beta      = 0.4D0,
  !tqr=.true.
/
ATOMIC_SPECIES
Fe  28.086 Fe.pz-nd-rrkjus.UPF
ATOMIC_POSITIONS
Fe  0.34920540000000   0.71269000000000   0.52555710000000
Fe  0.56194210000000   0.32794770000000   0.42798940000000
Fe  0.79192490000000   0.88443490000000   0.64274900000000
Fe  0.24752070000000   0.46290370000000   0.43781910000000
Fe  0.84052400000000   0.41421030000000   0.04255360000000
Fe  0.55634960000000   0.96599890000000   0.82645560000000
Fe  0.68585010000000   0.78494010000000   0.82199290000000
Fe  0.42998860000000   0.19744220000000   0.78271480000000
Fe  0.79046670000000   0.01821730000000   0.87174760000000
Fe  0.06383810000000   0.20267300000000   0.67813100000000
Fe  0.21601120000000   0.57720020000000   0.70281880000000
Fe  0.21489940000000   0.34540090000000   0.78378960000000
Fe  0.96511760000000   0.17625710000000   0.15038640000000
Fe  0.66427330000000   0.76599610000000   0.51883720000000
Fe  0.05766940000000   0.51545180000000   0.87171350000000
Fe  0.09359020000000   0.22024580000000   0.92056920000000
Fe  0.21891090000000   0.90581130000000   0.54666910000000
Fe  0.09503770000000   0.65259930000000   0.29189420000000
Fe  0.81200170000000   0.59440700000000   0.88170080000000
Fe  0.33256570000000   0.70415250000000   0.86396390000000
Fe  0.73143760000000   0.62044770000000   0.13407090000000
Fe  0.95219060000000   0.52732990000000   0.24801440000000
Fe  0.50844360000000   0.68557790000000   0.68120700000000
Fe  0.28225740000000   0.32552350000000   0.12274050000000
Fe  0.05587740000000   0.04546770000000   0.36464580000000
Fe  0.02990220000000   0.38550680000000   0.13206230000000
Fe  0.98260260000000   0.96492330000000   0.57289540000000
Fe  0.06112830000000   0.38261810000000   0.55860450000000
Fe  0.28822520000000   0.71834120000000   0.20642590000000
Fe  0.47954440000000   0.65392610000000   0.33606260000000
Fe  0.49885150000000   0.57637030000000   0.99203840000000
Fe  0.60798620000000   0.30173790000000   0.87227930000000
Fe  0.05178130000000   0.77633300000000   0.00551740000000
Fe  0.29978990000000   0.02594260000000   0.35200550000000
Fe  0.94567430000000   0.92732210000000   0.18876660000000
Fe  0.44114610000000   0.89486040000000   0.64584490000000
Fe  0.50595140000000   0.15199710000000   0.55560250000000
Fe  0.88293100000000   0.34139810000000   0.79893130000000
Fe  0.25658290000000   0.88388600000000   0.00705790000000
Fe  0.82061720000000   0.82179030000000   0.00295020000000
Fe  0.30396440000000   0.08127930000000   0.64570450000000
Fe  0.73471740000000   0.18774510000000   0.03862730000000
Fe  0.40100160000000   0.50022170000000   0.24480020000000
Fe  0.81285750000000   0.36954280000000   0.33446670000000
Fe  0.68773140000000   0.05418790000000   0.58645990000000
Fe  0.00252560000000   0.75154090000000   0.44769660000000
Fe  0.89794350000000   0.57647980000000   0.59687080000000
Fe  0.76769640000000   0.99593370000000   0.37493810000000
Fe  0.87149750000000   0.19495220000000   0.51873660000000
Fe  0.83623970000000   0.79640710000000   0.33547810000000
Fe  0.79188520000000   0.38870220000000   0.58158990000000
Fe  0.66899800000000   0.22313770000000   0.25376640000000
Fe  0.42965010000000   0.17055470000000   0.26670710000000
Fe  0.95270090000000   0.69141230000000   0.77245300000000
Fe  0.27694620000000   0.56150170000000   0.04789920000000
Fe  0.99167700000000   0.93379350000000   0.79502210000000
Fe  0.40139450000000   0.38781680000000   0.93639150000000
Fe  0.62046730000000   0.52627130000000   0.78608260000000
Fe  0.60986690000000   0.44843510000000   0.20291420000000
Fe  0.18985260000000   0.03543150000000   0.85892040000000
Fe  0.76645110000000   0.60803580000000   0.41788750000000
Fe  0.27347390000000   0.09213760000000   0.09126750000000
Fe  0.52318890000000   0.04375710000000   0.06178340000000
Fe  0.51706390000000   0.93964190000000   0.43576060000000
K_POINTS gamma
EOF
#
cat > test_3.in << EOF
&CONTROL
  outdir      = "$SCRATCH_DIR",
  pseudo_dir  = "$PSEUDO_DIR",
/
&SYSTEM
  ibrav     = 6,
  celldm(1) = 18.862D0,
  celldm(3) = 1.0125D0,
  nat       = 95,
  ntyp      = 2,
  ecutwfc   = 35.D0,
  ecutrho   = 400.D0,
/
&ELECTRONS
  conv_thr         = 1.D-8,
  mixing_beta      = 0.4D0,
  diago_david_ndim = 3,
  !tqr=.true.
/
ATOMIC_SPECIES
O   15.999 O.vdb.UPF
Zr  91.224 Zr.vdb.UPF
ATOMIC_POSITIONS
O       0.125773159    0.125773159    0.104156164
O       0.126750357    0.126750357    0.359129139
O       0.120591035    0.376245832    0.138023835
O       0.376245832    0.120591035    0.138023835
O       0.150262866    0.382649341    0.390818365
O       0.382649341    0.150262866    0.390818365
O       0.374996125    0.374996125    0.124185015
Zr      0.000612655    0.000612655   -0.005751244
Zr     -0.000628808    0.247570077    0.246340868
Zr      0.247570077   -0.000628808    0.246340868
Zr      0.250474512    0.250474512   -0.004062341
O       0.625578479    0.124421921    0.100277109
O       0.630711659    0.119286087    0.353548454
O       0.629400194    0.373754706    0.138024894
O       0.875850411    0.124855180    0.140884972
O       0.599732982    0.367345973    0.390819736
O       0.877045779    0.126367141    0.394385811
O       0.874995036    0.375005779    0.100289514
O       0.874995360    0.374997301    0.353660411
Zr      0.496992170   -0.000616018   -0.008236449
Zr      0.512569122    0.237428520    0.236775183
Zr      0.752691814   -0.002688371    0.246191095
Zr      0.750615376    0.253008645   -0.008236940
O       0.124421921    0.625578479    0.100277109
O       0.119286087    0.630711659    0.353548454
O       0.124855180    0.875850411    0.140884972
O       0.373754706    0.629400194    0.138024894
O       0.126367141    0.877045779    0.394385811
O       0.367345973    0.599732982    0.390819736
O       0.375005779    0.874995036    0.100289514
O       0.374997301    0.874995360    0.353660411
Zr     -0.000616018    0.496992170   -0.008236449
Zr     -0.002688371    0.752691814    0.246191095
Zr      0.237428520    0.512569122    0.236775183
Zr      0.253008645    0.750615376   -0.008236940
O       0.117884435    0.117884435    0.614354071
O       0.126069055    0.126069055    0.864018630
O       0.124099418    0.368979378    0.647565656
O       0.368979378    0.124099418    0.647565656
O       0.126482390    0.375125238    0.899728723
O       0.375125238    0.126482390    0.899728723
O       0.375000951    0.375000951    0.593148822
O       0.374997145    0.374997145    0.863141532
Zr     -0.002539837   -0.002539837    0.499407769
Zr     -0.003201395    0.246975842    0.755124067
Zr      0.246975842   -0.003201395    0.755124067
Zr      0.240704574    0.240704574    0.511492014
O       0.132784953    0.617216670    0.604991051
O       0.125707105    0.624300377    0.858705885
O       0.127805173    0.867401069    0.645972832
O       0.381021601    0.625906817    0.647563983
O       0.124853419    0.875495228    0.900313336
O       0.374877404    0.623514622    0.899728498
O       0.374996064    0.875003084    0.604972655
O       0.374998620    0.874997623    0.860749908
Zr      0.003035758    0.498755513    0.499877266
Zr      0.000142706    0.749856693    0.755068667
Zr      0.250044786    0.499958505    0.751725045
Zr      0.251245380    0.746965185    0.499875748
O       0.617216670    0.132784953    0.604991051
O       0.624300377    0.125707105    0.858705885
O       0.625906817    0.381021601    0.647563983
O       0.867401069    0.127805173    0.645972832
O       0.623514622    0.374877404    0.899728498
O       0.875495228    0.124853419    0.900313336
O       0.875003084    0.374996064    0.604972655
O       0.874997623    0.374998620    0.860749908
Zr      0.498755513    0.003035758    0.499877266
Zr      0.499958505    0.250044786    0.751725045
Zr      0.749856693    0.000142706    0.755068667
Zr      0.746965185    0.251245380    0.499875748
O       0.624227310    0.624227310    0.104153807
O       0.623248856    0.623248856    0.359128804
O       0.625156988    0.874144577    0.140886290
O       0.874144577    0.625156988    0.140886290
O       0.623630068    0.872954337    0.394385672
O       0.872954337    0.623630068    0.394385672
O       0.875003741    0.875003741    0.100670052
O       0.874997882    0.874997882    0.355700396
Zr      0.499523586    0.499523586   -0.004057943
Zr      0.502431262    0.750629301    0.246337395
Zr      0.750629301    0.502431262    0.246337395
Zr      0.749391052    0.749391052   -0.005749174
O       0.632117549    0.632117549    0.614355011
O       0.623937346    0.623937346    0.864019975
O       0.622189105    0.882600474    0.645973009
O       0.882600474    0.622189105    0.645973009
O       0.625148824    0.874507899    0.900313581
O       0.874507899    0.625148824    0.900313581
O       0.874997550    0.874997550    0.609292757
O       0.874998968    0.874998968    0.860732671
Zr      0.509296679    0.509296679    0.511490822
Zr      0.503026576    0.753201014    0.755126269
Zr      0.753201014    0.503026576    0.755126269
Zr      0.752538644    0.752538644    0.499403990
K_POINTS gamma
EOF
#
cat > test_4.in << EOF
&CONTROL
  outdir      = "$SCRATCH_DIR",
  pseudo_dir  = "$PSEUDO_DIR",
/
&SYSTEM
  nosym                  = .TRUE.,
  ibrav                  = 0,
  celldm(1)              = 9.4205D0,
  nat                    = 27,
  ntyp                   = 1,
  ecutwfc                = 25.D0,
  ecutrho                = 200.D0,
  nspin                  = 2,
  starting_magnetization =  0.2,
  occupations            = "smearing",
  degauss                = 0.03,
  smearing               = "m-p",
/
&ELECTRONS
  diago_david_ndim = 3,
  conv_thr         = 1.0D-8,
  mixing_mode      = "local-TF",
  mixing_beta      = 0.3D0,
  !tqr=.true.
/
ATOMIC_SPECIES
Ni  1.0  Ni-pbe-us.van
ATOMIC_POSITIONS bohr
Ni       2.439517811  17.638856161   3.821747010
Ni       4.846478293  13.554044534   3.706780995
Ni       7.155630272   9.467729629   3.858729832
Ni       4.815605572  21.701436249   3.811182901
Ni       7.174913802  17.593099934   3.740003759
Ni       9.583597077  13.523783949   3.733828854
Ni      11.876375223  17.663300748   3.843058304
Ni      14.231685096  13.568494164   3.786619345
Ni      16.581686335   9.479236118   3.800600054
Ni       2.321936411  14.988202853  -0.043141977
Ni       4.696666302  10.888860445  -0.032404402
Ni       7.039480132   6.820140430  -0.011147830
Ni       4.675740433  19.054980558  -0.021466924
Ni       7.058491010  14.968656678  -0.068488067
Ni       9.380392234  10.882527495  -0.043347197
Ni      11.750313530  14.998409511  -0.051923032
Ni      14.092167541  10.900993598  -0.013313201
Ni      16.467812943   6.805087208  -0.021769523
Ni       4.710250001  16.316784615  -3.845903015
Ni       7.065375001  12.237588474  -3.845903015
Ni       9.420500001   8.158392334  -3.845903015
Ni      -2.355125000  20.395980850  -3.845903015
Ni       9.420500001  16.316784615  -3.845903015
Ni       2.355125002  12.237588474  -3.845903015
Ni       7.062224016  20.395980850  -3.845903015
Ni      11.772474017  12.237588474  -3.845903015
Ni      14.127599017  16.316784615  -3.845903015
K_POINTS automatic
2 2 1  0 0 0
CELL_PARAMETERS { hexagonal }
   1.50000    0.00000000000000000000    0.00000
  -0.75000    1.29903810567665797012    0.00000
   0.00000    0.00000000000000000000    2.20000
EOF
#
# ... the benchmark starts here
#
for i in $( seq ${num_of_tests} ); do
   #
   printf " working on test_${i} ..."
   #
   $PREFIX $EXE $POSTFIX -in $PWD/test_${i}.in &> $PWD/test_${i}.out
   #
   printf " done\n"
   #
done
#
# ... end of tests
#
# ... output files are parsed here (the bench score is also computed here)
#
printf "\n %s   %s   %s    %s    %s     %s      %s\n\n" \
     "test" "nbndx" "npwx" "cpu-time" "total energy" "ref. energy"
#     "test" "nbndx" "npwx" "cpu-time" "I/O-time" "total energy" "ref. energy"
#
score="0.0"
#
for i in $( seq ${num_of_tests} ); do
   #
   file=test_${i}.out
   #
   check=$( grep "convergence has been achieved" ${file} | awk '{print $4}' )
   #
   if [[ "${check}" !=  "achieved" ]]; then
      #
      echo "test_${i} :  convergence has NOT been achieved"; exit
      #
   fi
   #
   tcpu=$( grep "electrons" ${file} | grep WALL  | awk '{print $5}' )
   #tcpu=$( grep "electrons" ${file} | grep CPU  | awk '{print $3}'  )
   #tcpu=${tcpu:0:${#tcpu}-1}
   #tio=$(  grep "davcio"            ${file}     | awk '{print $3}'  )

   # https://pranabdas.github.io/espresso/hands-on/scf
   #nbndx=$( grep "Kohn-Sham Wave" ${file} | cut -d'(' -f2 | awk '{print $2}' \
   #         | sed 's/)//' )
   nbndx=$( grep Sum ${file} | awk '{print $7}') # Number of plane waves
   #npwx=$(  grep "Kohn-Sham Wave" ${file} | cut -d'(' -f2 | awk '{print $1}' \
   #         | sed 's/,//' )
   npwx=$( grep Kohn-Sham ${file} | awk '{print $5}' ) # Number of bands

   ener=$( grep "!    total energy" ${file}     | awk '{print $5}' )

   printf "    %i    %4i  %5i  %10s  %16.8f %16.8f\n" \
        ${i} ${nbndx} ${npwx} ${tcpu} ${ener} ${ref_e[${i}]}
   
   tcpu=$( echo ${tcpu} | awk -F s '{print $1}' )
   #
   result=$( echo "(${ref_t[${i}]}/${tcpu}*100.0)/${num_of_tests}.0" | bc -l )
   #
   score=$( echo "${score} + ${result}" | bc -l )
   #
done
#
message="(100.00 is the score of the reference system)"
#
printf "\n $ARCH score is %6.2f ${message}\n\n" ${score}
#
# ... end of the script
#
