# Modelo Generado por: UCAS2D
# Tipo de Modelo
    wipe all;							# Limpiar Variables
    model BasicBuilder -ndm 2 -ndf 2;	# Define Modelo, ndm = #dimension--> 2D, ndf = #GDL
# Tipo de Analisis
# Definir tipo de analisis:  "pushover" = pushover
	set analysisType "pushover";
	if {$analysisType == "pushover"} {
		set dataDir Armadura_t_p;			# name of output folder
		file mkdir $dataDir;				# create output folder
}
# Definir Estructura
# TABLA DE NODOS
# Node #Nodo CoordenadaX CoordenadaY
    node 1   0   0
    node 2 200   0
    node 3 400   0
    node 4 600   0
    node 5 800   0
    node 6 200 100
    node 7 400 200
    node 8 600 100
# RESTRICCIONES
# Fix #Nodo GDLX GDLY 	GDL --> 0 = Libre   /   0 = Restringuido
    fix 1 0 1
    fix 5 1 1
    fix 7 1 1
# Comportamiento de Material
# Tipo	Etiqueta	Fy 	E	%E
	uniaxialMaterial Steel01 2 0.2812 253.4564 0.01
# Conectividad 
# Element Truss #Elemento Ni Nf Area #Comportamiento
    element Truss 1 1 2 900 2
    element Truss 2 2 3 25 2
    element Truss 3 3 4 900 2
    element Truss 4 4 5 900 2
    element Truss 5 1 6 900 2
    element Truss 6 6 7 25 2
    element Truss 7 7 8 900 2
    element Truss 8 8 5 900 2
    element Truss 9 6 2 25 2
    element Truss 10 7 3 25 2
    element Truss 11 8 4 900 2
    element Truss 12 6 3 25 2
    element Truss 13 3 8 900 2
# Guardar Datos
# Datos de Nodos 				 #Nombre_del_Archivo 		  # Nodos 			    # GDL
	recorder Node -file $dataDir/Drift_Armadura_DSP.txt -time -node 6 -dof 1 disp;
# Analisis Configuracion
if {$analysisType == "pushover"} {
	puts "Running Pushover..."
	set lat2 1.0;
	pattern Plain 200 Linear {
					load 6 $lat2 0.0;
	}
# Parametros de Desplazaminetos
	set NodeControl 6;					# Nodo de Control
	set IDctrlDOF 1;					# GDL de aplicacion de carga --> Ux = 1
	set d_ult 100 					# Desplazamiento maximo
	set Dincr [expr 0.001];				# Incremento de desplazamiento
# Configuracion del analisis
	constraints Plain;					# how it handles boundary conditions
	numberer Plain;						# renumber dofs to minimize band-width (optimization)
	system BandGeneral;					# how to store and solve the system of equations in the analysis (large model: try UmfPack)
	test EnergyIncr 1.e-008 1000 0;		# tolerance, max iterations
algorithm Newton -initial;					# use Newtons solution algorithm: updates tangent stiffness at every iteration
	integrator DisplacementControl  $NodeControl   $IDctrlDOF $Dincr;	# use displacement-controlled analysis
	analysis Static;					# define type of analysis: static for pushover
	set Nsteps [expr int($d_ult/$Dincr)];# number of pushover analysis steps
#	set ok [analyze $Nsteps];			# this will return zero if no convergence problems were encountered
	set ok 0	 	;  	   # Flag que indica convergencia
	set Vcurr [getTime]	;  # Cortante basal actual
	set controlDisp [nodeDisp $NodeControl  1]  ;  # Controlando desplazamiento de nodo
	puts "Cuadro iterativo ....."
while {$controlDisp <= $d_ult && $Vcurr >= -100.0} {                                          #$ok == 0
	set controlDisp [nodeDisp $NodeControl  1]
	set ok [analyze 1]
	# Si el analisis falla se puede tratar de variar los parametros para que converja
	if {$ok != 0} {
		puts stdout ""
		puts stdout "Intentar Newton with Initial Tangent .."
		test NormDispIncr   1.e-006 1000 0
		algorithm Newton -initial
		set ok [analyze 1]
     		if {$ok == 0} {puts stdout "***** Initial Newton funciono .. regreso a Newton"}
		#eval "algorithm Newton"
		puts stdout ""
	}
	if {$ok != 0} {
		puts stdout ""
		puts stdout "Intentar Broyden .."
		algorithm Broyden 8
		set ok [analyze 1 ]
		if {$ok == 0} {puts stdout "***** Broyden funciono .. regreso a Newton"}
		#eval "algorithm Newton"
		puts stdout ""
	}
	if {$ok != 0} {
		puts stdout ""
		puts stdout "Intentar NewtonWithLineSearch .."
		algorithm NewtonLineSearch -type InitialInterpolation -tol 0.8 -maxIter 100
		set ok [analyze 1]
if {$ok == 0} {puts stdout "***** NewtonWithLineSearch funciono .. regreso a Newton"}
		#eval "algorithm Newton"
		puts stdout ""
	}
	set Vcurr [getTime]  ;  # Retrieve base shear
}
if {$ok != 0} {
	puts stderr "El analisis fallo en converger al desplazamiento: $controlDisp en el nodo $NodeControl con cortante basal $Vcurr"
} else {
	puts stdout "Pushover Analysis completado exitosamente"
}  ;
}
wipe all;
