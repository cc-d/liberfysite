from os.path import abspath, join, dirname

POLL_EVERY = 5

STATUS_FILES = {
    'liberlife': join(abspath(dirname(__file__)), 'life.liberfy.ai.log'),
    'open2fa': join(abspath(dirname(__file__)), 'open2fa.liberfy.ai.log'),
}
