module VendingAlle (
    input wire clk,            // Reloj de entrada (50 MHz)
    input wire reset,			// Señal de reset
    input wire boton_moneda,
	 input wire boton_p1,		
	 input wire boton_p2,
	 input wire boton_p3,
	 input wire boton_p4,
    output reg [6:0] seg,      // Salida para segmentos de los displays
    output reg [1:0] an,        // Señal de anodos para seleccionar el display
	 output reg [3:0] motor
);

reg [25:0] clk_divider;       // Contador para dividir el reloj para segundos
reg [16:0] multiplex_div;     // Contador para multiplexar los displays (ajustado para 500 Hz)
reg [6:0] contador;
reg [7:0] prueba;
reg [7:0] prueba1;
reg [7:0] prueba2;
reg [7:0] prueba3;
reg [7:0] prueba4;
reg [3:0] digit;
reg boton_moneda_prev;               // Estado previo del botón
reg boton_prev_1; 
reg boton_prev_2; 
reg boton_prev_3; 
reg boton_prev_4;
reg [25:0] contador1; // tiempo de activacion del motor
reg [25:0] contador2;
reg [25:0] contador3;
reg [25:0] contador4;


// Contador principal y multiplexor
always @(posedge clk or posedge reset) begin
    if (reset) begin
        clk_divider <= 0;
        multiplex_div <= 0;
        contador <= 0;
        boton_moneda_prev <= 1'b0; // Inicializar el estado previo del botón
		  boton_prev_1 <= 1'b0; // Inicializar el estado previo del botón
		  boton_prev_2 <= 1'b0; // Inicializar el estado previo del botón
		  boton_prev_3 <= 1'b0; // Inicializar el estado previo del botón
		  boton_prev_4 <= 1'b0; // Inicializar el estado previo del botón
		  motor <=0;
    end else begin
        clk_divider <= clk_divider + 1;
        multiplex_div <= multiplex_div + 1;
		  //
		   
		  if (contador1 > 0) begin  // Contar hasta 50 millones para 1 segundo
								contador1 <= contador1 - 1;
							end else begin
								//contador1 <= 0;  // Reiniciar el contador después de 1 segundo
								motor[0] <= 0;   // Establecer el pin de salida en 0
							end
							
							
			if (contador2 > 0) begin  // Contar hasta 50 millones para 1 segundo
								contador2 <= contador2 - 1;
							end else begin
								//contador1 <= 0;  // Reiniciar el contador después de 1 segundo
								motor[1] <= 0;   // Establecer el pin de salida en 0
							end
							
			if (contador3 > 0) begin  // Contar hasta 50 millones para 1 segundo
								contador3 <= contador3 - 1;
							end else begin
								//contador1 <= 0;  // Reiniciar el contador después de 1 segundo
								motor[2] <= 0;   // Establecer el pin de salida en 0
							end
							
			if (contador4 > 0) begin  // Contar hasta 50 millones para 1 segundo
					contador4 <= contador4 - 1;
				end else begin
					//contador1 <= 0;  // Reiniciar el contador después de 1 segundo
					motor[3] <= 0;   // Establecer el pin de salida en 0
				end
		  //
        if(boton_moneda != boton_moneda_prev) begin
            // Detección de flanco ascendente o descendente
            if(boton_moneda && !boton_moneda_prev) begin
                // Flanco ascendente: el botón se ha presionado
                prueba <= prueba + 1;
            end
            boton_moneda_prev <= boton_moneda;
        end
		  
		   if(boton_p1 != boton_prev_1) begin
            // Detección de flanco ascendente o descendente
            if(boton_p1 && !boton_prev_1) begin
                // Flanco ascendente: el botón se ha presionado
                prueba1 <= prueba1 + 1;
					 prueba2 <= 0;
					 prueba3 <= 0;
					 prueba4 <= 0;
            end
            boton_prev_1 <= boton_p1;
        end else if(boton_p2 != boton_prev_2) begin
            // Detección de flanco ascendente o descendente
            if(boton_p2 && !boton_prev_2) begin
                // Flanco ascendente: el botón se ha presionado
                prueba2 <= prueba2 + 1;
					 prueba1 <= 0;
					 prueba3 <= 0;
					 prueba4 <= 0;
            end
            boton_prev_2 <= boton_p2;
        end else if(boton_p3 != boton_prev_3) begin
            // Detección de flanco ascendente o descendente
            if(boton_p3 && !boton_prev_3) begin
                // Flanco ascendente: el botón se ha presionado
                prueba3 <= prueba3 + 1;
					 prueba1 <= 0;
					 prueba2 <= 0;
					 prueba4 <= 0;
            end
            boton_prev_3 <= boton_p3;
        end else if(boton_p4 != boton_prev_4) begin
            // Detección de flanco ascendente o descendente
            if(boton_p4 && !boton_prev_4) begin
                // Flanco ascendente: el botón se ha presionado
                prueba4 <= prueba4 + 1;
					 prueba1 <= 0;
					 prueba2 <= 0;
					 prueba3 <= 0;
            end
            boton_prev_4 <= boton_p4;
        end
        
        if (clk_divider == 2000000 - 1) begin
            clk_divider <= 0;
            if (prueba != 0) begin // Cambio
                prueba <= 0;
                if (boton_moneda) begin // Asegura que el contador solo se incremente cuando el botón está presionado
					 
							if(contador !=95) begin 
                    contador <= contador + 5;
						  end
                end
            end
				
				if (prueba1 != 0 && motor==0) begin // Cambio
                prueba1 <= 0;
                if (boton_p1) begin // Asegura que el contador solo se incremente cuando el botón está presionado
					 
							if(contador >= 5) begin 
                    contador <= contador - 5;
						  contador1 <=50000000;
						  motor[0] <= 1;  // Establecer el pin de salida en 1
//							if (contador1 < 50000000) begin  // Contar hasta 50 millones para 1 segundo
//								contador1 <= contador1 + 1;
//								motor[0] <= 1;  // Establecer el pin de salida en 1
//							end else begin
//								contador1 <= 0;  // Reiniciar el contador después de 1 segundo
//								motor[0] <= 0;   // Establecer el pin de salida en 0
//							end
							
						  end
                end
            end else if (prueba2 != 0 && motor==0) begin // Cambio
                prueba2 <= 0;
					 #2
                if (boton_p2) begin // Asegura que el contador solo se incremente cuando el botón está presionado
					 
							if(contador >= 5) begin 
                    contador <= contador - 5;
						  contador2 <=50000000;
						  motor[1] <= 1;

						  
						  
						  end
                end
            end else if (prueba3 != 0 && motor==0) begin // Cambio
                prueba3 <= 0;
					 #2
                if (boton_p3) begin // Asegura que el contador solo se incremente cuando el botón está presionado
					 
							if(contador >= 15) begin 
                    contador <= contador - 15;
						  contador3 <=50000000;
						  motor[2] <= 1;
						  
						  
						  end
                end
            end else if (prueba4 != 0 && motor==0) begin // Cambio
                prueba4 <= 0;
					 #2
                if (boton_p4) begin // Asegura que el contador solo se incremente cuando el botón está presionado
					 
							if(contador >= 20) begin 
                    contador <= contador - 20;
						  contador4 <=50000000;
						  motor[3] <= 1;
						  end
                end
            end
        end
        if (multiplex_div == 100000 - 1) begin  // Cambia a la siguiente visualización cada 100,000 ciclos
            multiplex_div <= 0;
        end
    end
end

// Decodificador de 7 segmentos
function [6:0] decodificar_7segmentos;
    input [3:0] digit;
    case (digit)
        4'd0: decodificar_7segmentos = 7'b0111111;
        4'd1: decodificar_7segmentos = 7'b0000110;
        4'd2: decodificar_7segmentos = 7'b1011011;
        4'd3: decodificar_7segmentos = 7'b1001111;
        4'd4: decodificar_7segmentos = 7'b1100110;
        4'd5: decodificar_7segmentos = 7'b1101101;
        4'd6: decodificar_7segmentos = 7'b1111101;
        4'd7: decodificar_7segmentos = 7'b0000111;
        4'd8: decodificar_7segmentos = 7'b1111111;
        4'd9: decodificar_7segmentos = 7'b1101111;
        default: decodificar_7segmentos = 7'b0000000;  // Todos apagados
    endcase
endfunction

// Mux para controlar los displays
always @(posedge clk or posedge reset) begin
    if (reset) begin
        an <= 2'b00;  // Apaga ambos displays (lógica activa alta)
        seg <= 7'b0000000;  // Apaga todos los segmentos
    end else begin
        // Apaga ambos displays antes de cambiar
        an <= 2'b00;
        seg <= 7'b0000000;
        
        // Espera un pequeño tiempo para asegurar que los displays están apagados
        #1;

        // Multiplexar displays
        case (multiplex_div[16])  // Cambia el display cada 100,000 ciclos para lograr 500 Hz
            1'b0: begin
                an <= 2'b10;  // Enciende display de las unidades (lógica activa alta)
                digit <= contador / 10;
                seg <= decodificar_7segmentos(digit);  // La lógica de segmentos es directa, no invertida
           end
            1'b1: begin
                an <= 2'b01;  // Enciende display de las decenas (lógica activa alta)
                digit <= contador % 10;
                seg <= decodificar_7segmentos(digit);  // La lógica de segmentos es directa, no invertida
            end
        endcase


    end
end

endmodule
