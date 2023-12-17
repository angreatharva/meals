import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/favourites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMeals = ref.watch(favouriteMealsProvider);
    final isfavourite = favouriteMeals.contains(meal);
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Hero(
                tag: meal.id,
                child: Image.network(
                  meal.imageUrl,
                  height: 300,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton(
                  iconSize: 35,
                  onPressed: () {
                    final wasAdded = ref
                        .read(favouriteMealsProvider.notifier)
                        .toggleMealFavouriteStatus(meal);
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(milliseconds: 1500),
                        content: Text(wasAdded
                            ? 'Meal added as favourite'
                            : 'Meal removed from favourite'),
                      ),
                    );
                  },
                  icon: AnimatedSwitcher(
                    transitionBuilder: (child,animation){
                      return RotationTransition(
                        turns: Tween<double>(
                          begin: 0.8,
                          end: 1.0,
                        ).animate(animation),
                        child: child,);
                    },
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      isfavourite ? Icons.star : Icons.star_border_outlined,
                      key: ValueKey(isfavourite),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ingredients",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          for (final ingredient in meal.ingredients)
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                ingredient,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Steps",
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          for (final steps in meal.steps)
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 8),
              child: Text(
                steps,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
