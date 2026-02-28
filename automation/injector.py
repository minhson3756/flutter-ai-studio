import os

def inject_to_flutter(app_path, feature_name, generated_code):
    feature_dir = os.path.join(app_path, "lib", "src", "presentation", feature_name.lower())
    cubit_dir = os.path.join(feature_dir, "cubit")

    os.makedirs(cubit_dir, exist_ok=True)

    # Ghi file Screen
    with open(os.path.join(feature_dir, f"{feature_name.lower()}_screen.dart"), "w") as f:
        f.write(generated_code['screen'])

    # Ghi file Cubit
    with open(os.path.join(cubit_dir, f"{feature_name.lower()}_cubit.dart"), "w") as f:
        f.write(generated_code['cubit'])

    # Ghi file State
    with open(os.path.join(cubit_dir, f"{feature_name.lower()}_state.dart"), "w") as f:
        f.write(generated_code['state'])