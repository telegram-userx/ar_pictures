part of 'ar_data_loader_screen.dart';

class _Screen extends StatefulWidget {
  final PhotoAlbumEntity? photoAlbum;

  const _Screen({
    required this.photoAlbum,
  });

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  late final List<ReactionDisposer> _disposers;
  bool hasErrors = false;

  @override
  void initState() {
    _disposers = [
      reaction((_) => Provider.of<ArDataLoaderStore>(context).isDownloadSuccess, (bool isSuccess) {
        if (isSuccess) {
          sl<AppRouter>().replace(const ArJsWebviewRoute());
        }
      }),
    ];

    super.initState();
  }

  @override
  void dispose() {
    for (final disposer in _disposers) {
      disposer();
    }

    super.dispose();
  }

  _onDownload() async {
    try {
      await Provider.of<ArDataLoaderStore>(context).startDownloading();
    } catch (error, stackTrace) {
      Logger.e(error, stackTrace);

      setState(() {
        hasErrors = true;
      });
    } finally {
      Provider.of<ArDataLoaderStore>(context).setIsDownloading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.padding),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: Observer(builder: (_) {
            if (hasErrors) {
              return Center(
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context.maybePop();
                        },
                        child: Text(context.translations.cancel),
                      ),
                    ),
                    Space.h20,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _onDownload,
                        child: Text(context.translations.retry),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (Provider.of<ArDataLoaderStore>(context).isDownloading) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.translations.downloadInProgress(
                      total: Provider.of<ArDataLoaderStore>(context).totalSizeInMegaBytes.toStringAsFixed(2),
                      received: Provider.of<ArDataLoaderStore>(context).downloadProgressTotal.toStringAsFixed(2),
                    ),
                    style: context.textTheme.titleLarge,
                  ),
                  Space.v20,
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.translations.areYouSureDownload(
                      megabytes: Provider.of<ArDataLoaderStore>(context).totalSizeInMegaBytes.toStringAsFixed(2),
                    ),
                    style: context.textTheme.titleLarge,
                  ),
                  Space.v20,
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.maybePop();
                          },
                          child: Text(context.translations.cancel),
                        ),
                      ),
                      Space.h20,
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _onDownload,
                          child: Text(context.translations.download),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
