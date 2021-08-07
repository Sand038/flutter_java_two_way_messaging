package com.sand.flutter_java_two_way_messaging;

import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleObserver;
import androidx.lifecycle.OnLifecycleEvent;
import androidx.lifecycle.ProcessLifecycleOwner;

import com.google.gson.Gson;
import com.sand.flutter_java_two_way_messaging.models.Message;
import com.sand.flutter_java_two_way_messaging.models.Messages;
import com.sand.flutter_java_two_way_messaging.models.MessagesWithCount;

import java.util.Arrays;
import java.util.concurrent.TimeUnit;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers;
import io.reactivex.rxjava3.core.Observable;
import io.reactivex.rxjava3.disposables.CompositeDisposable;
import io.reactivex.rxjava3.disposables.Disposable;
import io.reactivex.rxjava3.schedulers.Schedulers;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "samples.flutter.dev/messages";

    final int[] count = {0};

    private final CompositeDisposable compositeDisposable = new CompositeDisposable();
    private Disposable disposable;
    private MethodChannel methodChannel;
    private boolean appStarted = false;
    Gson gson = new Gson();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        // 700 delay
        ProcessLifecycleOwner.get().getLifecycle().addObserver(new LifecycleObserver() {
            // TODO find a better way to ignore firing on resume at app start
            @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
            public void connectListener() {
                if (appStarted) {
                    System.out.println("app resumed");
                    testPolling();
                }
                appStarted = true;
            }

            // TODO check if on pause calling when app closed
            @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
            public void disconnectListener() {
                disposable.dispose();
                System.out.println("app paused");
            }
        });

        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        methodChannel
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("getMessage")) {
                                Messages messages = gson.fromJson((String) call.argument("messages"), Messages.class);
                                String message = getMessage(messages);
                                if (message != null) {
                                    result.success(message);
                                } else {
                                    result.error("UNAVAILABLE", "Error getting messages.", null);
                                }
                            } else if (call.method.equals("testPolling")) {
                                testPolling();
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private String getMessage(Messages messages) {
        Message message = messages.getMessages().get(0);
        int value = message.getValue() * 10;

        MessagesWithCount messagesWithCount = new MessagesWithCount(value,
                Arrays.asList(new Message("Result " + message.getText(), value)));
        return new Gson().toJson(messagesWithCount);
    }

    private void testPolling() {
        disposable = Observable.interval(1000, 1000,
                TimeUnit.MILLISECONDS)
                .observeOn(AndroidSchedulers.mainThread())
                .subscribeOn(Schedulers.io())
                .doOnSubscribe(compositeDisposable::add)
                .subscribe(aLong -> printCount(count), Throwable::printStackTrace);
    }

    private void printCount(int[] count) {
        if (count[0] % 10 == 0 && count[0] != 0) {
            sendUpdates();
        } else {
            System.out.println("new value = " + count[0]++);
        }

    }

    private void sendUpdates() {
        Message pollingResult = getPollingResult();
        methodChannel.invokeMethod("getUpdates", gson.toJson(pollingResult), new MethodChannel.Result() {
            @Override
            public void success(Object o) {
                System.out.println("dart method called successfully");
            }

            @Override
            public void error(String s, String s1, Object o) {
                System.err.println(s + " => " + s1);
            }

            @Override
            public void notImplemented() {
                System.err.println("not implemented");
            }
        });
        count[0]++;
    }

    private Message getPollingResult() {
        return new Message("polling cycle no => ", count[0]);
    }

}
