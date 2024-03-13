import 'package:flutter/material.dart';
import '../models/Product.dart';
import '../services/WishListService.dart';

class ParentProduct extends StatelessWidget {
  final List<String> children = ['Child 1', 'Child 2', 'Child 3'];
  final String childid; // Sample list of children
  ParentProduct(this.childid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Page'),
      ),
      body: ChildCard(
              childName: childid, childID: 2.toString())
        
    );
  }
}

class ChildCard extends StatelessWidget {
  final String childName;
  final String childID;
  const ChildCard({required this.childName, required this.childID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the child's wishlist page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChildWishlistPage(childName: childName, childID: childID),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/child_avatar.jpg'),
                radius: 30,
              ),
              const SizedBox(height: 8),
              Text(
                childName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChildWishlistPage extends StatefulWidget {
  final String childName;
  final String childID;

  ChildWishlistPage({required this.childName, required this.childID});

  @override
  _ChildWishlistPageState createState() => _ChildWishlistPageState();
}

class _ChildWishlistPageState extends State<ChildWishlistPage> {
  List<Product> wishlistProducts = [];

  @override
  void initState() {
    super.initState();
    fetchWishlistProducts(widget.childID);
  }

  Future<void> fetchWishlistProducts(String childID) async {
    try {
      // Fetch wished products from the wishlist
      List<Product> products =
          await WishListService.getAllProductDetails(childID);
      setState(() {
        wishlistProducts = products;
      });
    } catch (error) {
      // Handle errors if any
      print('Error fetching wishlist products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.childName}\'s Wishlist'),
      ),
      body: ListView.builder(
        itemCount: wishlistProducts.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removeProduct(index, widget.childID);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ProductCard(
              product: wishlistProducts[index],
              onDelete: () => _removeProduct(index, widget.childID),
            ),
          );
        },
      ),
    );
  }

  void _removeProduct(int index, String childId) async {
    // Get the product to be deleted
    Product productToRemove = wishlistProducts[index];

    // Remove the product from the list
    setState(() {
      wishlistProducts.removeAt(index);
    });

    // Call the service function to remove the product from the database
    await WishListService.deleteWishedProduct("2", productToRemove.id);

    // Fetch the updated wishlist after deletion
    await fetchWishlistProducts(childId);
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductCard({required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Price: \$${product.price}',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Type: ${product.type}',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeProductFromWishlist(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Colors.blue),
                      onPressed: () {
                        WishListService.updateWishedProduct("2", product.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Image.asset(
              product.image ?? '',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  void _removeProductFromWishlist(BuildContext context) {
    // Show a snackbar to indicate successful deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} removed from wishlist'),
      ),
    );

    // Call the onDelete callback to remove the product from the wishlist
    onDelete();
  }
}
