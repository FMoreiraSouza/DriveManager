import 'package:flutter/material.dart';

class FleetFormFieldWidget extends StatelessWidget {
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final ValueChanged<String> onChanged;
  final String labelText;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const FleetFormFieldWidget({
    super.key,
    required this.focusNode,
    this.nextFocusNode,
    required this.onChanged,
    required this.labelText,
    required this.textInputAction,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted:
          nextFocusNode != null ? (_) => nextFocusNode!.requestFocus() : (_) => focusNode.unfocus(),
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: labelText),
      validator: validator,
    );
  }
}

class FleetRegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onPlateChanged;
  final ValueChanged<String> onBrandChanged;
  final ValueChanged<String> onModelChanged;
  final ValueChanged<String> onMileageChanged;
  final ValueChanged<String> onTrackerImeiChanged;
  final FocusNode plateFocusNode;
  final FocusNode brandFocusNode;
  final FocusNode modelFocusNode;
  final FocusNode mileageFocusNode;
  final FocusNode trackerImeiFocusNode;
  final VoidCallback onSave;
  final bool isLoading;

  const FleetRegisterForm({
    super.key,
    required this.formKey,
    required this.onPlateChanged,
    required this.onBrandChanged,
    required this.onModelChanged,
    required this.onMileageChanged,
    required this.onTrackerImeiChanged,
    required this.plateFocusNode,
    required this.brandFocusNode,
    required this.modelFocusNode,
    required this.mileageFocusNode,
    required this.trackerImeiFocusNode,
    required this.onSave,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          FleetFormFieldWidget(
            focusNode: plateFocusNode,
            nextFocusNode: brandFocusNode,
            onChanged: onPlateChanged,
            labelText: 'Placa',
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a placa do veículo';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          FleetFormFieldWidget(
            focusNode: brandFocusNode,
            nextFocusNode: modelFocusNode,
            onChanged: onBrandChanged,
            labelText: 'Marca',
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a marca do veículo';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          FleetFormFieldWidget(
            focusNode: modelFocusNode,
            nextFocusNode: mileageFocusNode,
            onChanged: onModelChanged,
            labelText: 'Modelo',
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o modelo do veículo';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          FleetFormFieldWidget(
            focusNode: mileageFocusNode,
            nextFocusNode: trackerImeiFocusNode,
            onChanged: onMileageChanged,
            labelText: 'Quilometragem',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a quilometragem do veículo';
              }
              if (double.tryParse(value.replaceAll(',', '.')) == null) {
                return 'Quilometragem deve ser um número válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          FleetFormFieldWidget(
            focusNode: trackerImeiFocusNode,
            onChanged: onTrackerImeiChanged,
            labelText: 'IMEI do Rastreador',
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o IMEI do rastreador';
              }
              if (int.tryParse(value) == null) {
                return 'IMEI deve ser um número válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: isLoading ? null : onSave,
            child: const Text(
              'Salvar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
