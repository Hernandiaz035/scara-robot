# SCARA Robot

Diseño y Programacion de Robot tipo SCARA como Plotter, con fin educativo.

![Vista en Perspectiva del Robot][pers]

- El calculo de la tranformacion cienematica inversa esta adjunta en archivo [TCIProyecto](https://github.com/hernandiaz035/blob/master/Robot/TCIProyecto.m)

- El movimiento del robot se hace mediante la libreria [AccelStepper](https://github.com/adafruit/AccelStepper.git), enviando de manera empaquetada las posiciones angulares del robot, punto a punto dentro del espacio articular del dispositivo.

- El Software del dispositivo tiene programada una interrupcion que corresponde a un final de carrera que en la rutina de inicio permite establecer la posicion absoluta de la articulacion 1

- Debido a que los motores paso a paso, tienen tipicamente 200 pasos, es algo que se vuelve critico volviendo mas tosca la resolucion de los movimientos cuando la articulaion 2 tiene un angulo de cerca de 0°, por lo cual se opto en el diseño por hacer el uso de una reduccion por polea sincronica en la articulacion 1

![side]
![backpers]

[pers]: /images/pers.png
[side]: /images/side.png
[backpers]: /images/backpers.png