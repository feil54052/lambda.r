# Access Styles

## Usage

Install as a gem and include the usual ways.

### Styles

You can include:

```scss
@import "access-styles/color";
@import "access-styles/bootstrap";
@import "access-styles/layout";
@import "access-styles/mixins";
@import "access-styles/fonts";
@import "access-styles/typography";
@import "access-styles/progress-bar"; // for turbolinks progress-bar be sure to include the js
@import "access-styles/loading-animation"
```

### Javascripts

You can include:

```javascript
//= require access-styles/data_confirm
//= require access-styles/forms
//= require access-styles/progress_bar
```

### Variables

You can redefine these before you include the css

#### Basic Colors

```scss
$red:            #e54729;
$sky-blue:       invert($red);
$blue:           #002e62;
$yellow:         #ffcc00;
$green:          lighten(#55a602,8.5%);

$black:          #000;
$white:          #fff;
$mid-tone:       #9ea7ad;
$lighter-tone:   lighten($mid-tone, 30%);
$light-tone:     lighten($mid-tone, 15%);
$dark-tone:      darken($mid-tone, 30%);
$darker-tone:    darken($mid-tone, 45%);
```

#### Brand Colors

```scss
$brand-primary:       $blue;
$brand-success:       $green;
$brand-info:          $sky-blue;
$brand-warning:       $yellow;
$brand-danger:        $red;
```

#### Progress Bar

```scss
$progress-bar-background-color: $brand-info;
$progress-bar-height: 5px;
```

### Classes

#### Background Color

```scss
.bg-red
.bg-sky-blue
.bg-blue
.bg-yellow
.bg-green
```

#### Text Color

```scss
.text-red
.text-sky-blue
.text-blue
.text-yellow
.text-green
```

#### Layout Size

```scss
.section-xl
.section-l
.section-m
.section-s
```

#### Padding and Margin

```scss
.pad-(0 to 155 by 5)
.pad-horizontal-(0 to 155 by 5)
.pad-vertical-(0 to 155 by 5)
.pad-top-(0 to 155 by 5)
.pad-bottom-(0 to 155 by 5)
.pad-left-(0 to 155 by 5)
.pad-right-(0 to 155 by 5)
.margin-(0 to 155 by 5)
.margin-horizontal-(0 to 155 by 5)
.margin-vertical-(0 to 155 by 5)
.margin-top-(0 to 155 by 5)
.margin-left-(0 to 155 by 5)
.margin-right-(0 to 155 by 5)
.margin-bottom-(0 to 155 by 5)
.negative-top-(0 to 155 by 5)
.negative-bottom-(0 to 155 by 5)
```

#### Typography

```scss
.primary-header
.secondary-header

.header-xxl
.header-xl
.header-l
.header-m
.header-s

.text-xxl
.text-xl
.text-l
.text-m
.text-s

.text-black
.text-bold
.text-book
.text-light
```
