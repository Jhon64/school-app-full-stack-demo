import 'package:flutter/material.dart';
import 'package:listas_app/domain/entities/producto_entity.dart';

class ListProducts extends StatelessWidget {
  List<Product> products;

  ListProducts({super.key, required this.products,this.handleOnDelete,this.handleOnEdit});

  void Function(Product prod,int index)? handleOnDelete;
  void Function(Product prod,int index)? handleOnEdit;

  Widget CardProducto(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(product.nombre ?? ''),
              Expanded(
                  child: Text('S/. ${product.precio.toString() ?? '0.0'}',
                      textAlign: TextAlign.right)),
            ],
          ),
          const SizedBox(
            height: 2.0,
          ),
          Text(product.descripcion ?? '')
        ],
      ),
    );
  }

  Widget itemProduct(Product product,int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo del contenedor
        borderRadius: BorderRadius.circular(0), // Bordes redondeados
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(4, 4), // Sombra desplazada
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: CardProducto(product),
          ),
          Container(
              color: Colors.red,
              // width: 20.0,
              child: Center(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.white, // Establece el color del texto
                  ),
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    if (handleOnDelete != null) {
                      handleOnDelete!(product,index);
                    }
                  },
                  label: Text(''),
                ),
              )),
          Container(
              color: Colors.green,
              child: Center(
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.white, // Establece el color del texto
                  ),
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    if (handleOnEdit != null) {
                      handleOnEdit!(product,index);
                    }
                  },
                  label: Text(''),
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.builder(
      shrinkWrap: true,
      //ocupa espacio dependiendo de la lista
      // physics: NeverScrollableScrollPhysics(),
      // Evita conflictos de desplazamiento
      itemCount: products.length,
      itemBuilder: (context, index) {
        var product = products[index];
        return itemProduct(product,index);
      },
    ));
    ;
  }
}
