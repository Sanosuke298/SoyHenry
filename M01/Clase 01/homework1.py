def numeroBinario(numero):
    if type(numero) != int:
       return None
    if numero < -1:
       return None
    numero_binario = 0
    multiplicador = 1
    while numero != 0:
       numero_binario = numero_binario + numero % 2 * multiplicador
       numero //= 2
       multiplicador *= 10
    return numero_binario

def fraccion_a_Binario(numero):
    if type(numero) != float:
       return None
    if numero < -1:
       return None
    numero_binario = 0
    multiplicador = 0.1
    while numero > 0:
       numero *=2
       if numero >= 1:
         numero_binario = numero_binario + int(numero) * multiplicador
         numero = numero - int(numero)
         multiplicador *= 0.1
       else:
          numero_binario = numero_binario + int(numero) * multiplicador
          multiplicador *= 0.1
    return numero_binario


print(fraccion_a_Binario(0.3125))
